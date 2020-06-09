From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 82/93] bpf: factor out a bpf_trace_copy_string
 helper
Date: Mon, 08 Jun 2020 21:34:30 -0700
Message-ID: <20200609043430.w6Gil863r%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726831AbgFIEec (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:34:32 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, linux-mm@kvack.org, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org

From: Christoph Hellwig <hch@lst.de>
Subject: bpf: factor out a bpf_trace_copy_string helper

Split out a helper to do the fault free access to the string pointer
to get it out of a crazy indentation level.

Link: http://lkml.kernel.org/r/20200521152301.2587579-12-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/bpf_trace.c |   42 +++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 18 deletions(-)

--- a/kernel/trace/bpf_trace.c~bpf-factor-out-a-bpf_trace_copy_string-helper
+++ a/kernel/trace/bpf_trace.c
@@ -324,6 +324,28 @@ static const struct bpf_func_proto *bpf_
 	return &bpf_probe_write_user_proto;
 }
 
+static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
+		size_t bufsz)
+{
+	void __user *user_ptr = (__force void __user *)unsafe_ptr;
+
+	buf[0] = 0;
+
+	switch (fmt_ptype) {
+	case 's':
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+		strncpy_from_unsafe(buf, unsafe_ptr, bufsz);
+		break;
+#endif
+	case 'k':
+		strncpy_from_kernel_nofault(buf, unsafe_ptr, bufsz);
+		break;
+	case 'u':
+		strncpy_from_user_nofault(buf, user_ptr, bufsz);
+		break;
+	}
+}
+
 /*
  * Only limited trace_printk() conversion specifiers allowed:
  * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %pks %pus %s
@@ -406,24 +428,8 @@ fmt_str:
 				break;
 			}
 
-			buf[0] = 0;
-			switch (fmt_ptype) {
-			case 's':
-#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
-				strncpy_from_unsafe(buf, unsafe_ptr,
-						    sizeof(buf));
-				break;
-#endif
-			case 'k':
-				strncpy_from_kernel_nofault(buf, unsafe_ptr,
-							   sizeof(buf));
-				break;
-			case 'u':
-				strncpy_from_user_nofault(buf,
-					(__force void __user *)unsafe_ptr,
-							 sizeof(buf));
-				break;
-			}
+			bpf_trace_copy_string(buf, unsafe_ptr, fmt_ptype,
+					sizeof(buf));
 			goto fmt_next;
 		}
 
_
