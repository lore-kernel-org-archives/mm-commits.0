From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 114/118] init/main.c: fix misleading "This
 architecture does not have kernel memory protection" message
Date: Thu, 30 Jan 2020 22:17:23 -0800
Message-ID: <20200131061723.upjkoIjXq%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbgAaGRY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:17:24 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, christophe.leroy@c-s.fr, keescook@chromium.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, torvalds@linux-foundation.org

From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: init/main.c: fix misleading "This architecture does not have kernel memory protection" message

This message leads to thinking that memory protection is not implemented
for the said architecture, whereas absence of CONFIG_STRICT_KERNEL_RWX
only means that memory protection has not been selected at compile time.

Don't print this message when CONFIG_ARCH_HAS_STRICT_KERNEL_RWX is
selected by the architecture.  Instead, print "Kernel memory protection
not selected by kernel config."

Link: http://lkml.kernel.org/r/62477e446d9685459d4f27d193af6ff1bd69d55f.1578557581.git.christophe.leroy@c-s.fr
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/init/main.c~init-fix-misleading-this-architecture-does-not-have-kernel-memory-protection-message
+++ a/init/main.c
@@ -1104,6 +1104,11 @@ static void mark_readonly(void)
 	} else
 		pr_info("Kernel memory protection disabled.\n");
 }
+#elif defined(CONFIG_ARCH_HAS_STRICT_KERNEL_RWX)
+static inline void mark_readonly(void)
+{
+	pr_warn("Kernel memory protection not selected by kernel config.\n");
+}
 #else
 static inline void mark_readonly(void)
 {
_
