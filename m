From: akpm@linux-foundation.org
Subject: [merged] vsprintf-refactor-%pk-code-out-of-pointer.patch
 removed from -mm tree
Date: Thu, 30 Nov 2017 12:19:36 -0800
Message-ID: <20171130201936.6SsR4MgFa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52692 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751157AbdK3UTi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:19:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, catalin.marinas@arm.com, cfries@google.com, danielmicay@gmail.com, davem@davemloft.net, dvyukov@google.com, glider@google.com, Golden_Miller83@protonmail.ch, gregkh@linuxfoundation.org, ijc@hellion.org.uk, Jason@zx2c4.com, joe@perches.com, keescook@chromium.org, me@tobin.cc, mm-commits@vger.kernel.org, olorin@google.com, pbonzini@redhat.com, pmladek@suse.com, rkrcmar@redhat.com, rostedt@goodmis.org, sergey.senozhatsky@gmail.com, sfr@canb.auug.org.au, tixxdz@gmail.com, tj@kernel.org, tycho@tycho.ws, tytso@mit.edu, will.deacon@arm.com, william.c.roberts@intel.com


The patch titled
     Subject: vsprintf: refactor %pK code out of pointer()
has been removed from the -mm tree.  Its filename was
     vsprintf-refactor-%pk-code-out-of-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Tobin C. Harding" <me@tobin.cc>
Subject: vsprintf: refactor %pK code out of pointer()

Currently code to handle %pK is all within the switch statement in
pointer().  This is the wrong level of abstraction.  Each of the other
switch clauses call a helper function, pK should do the same.

Refactor code out of pointer() to new function restricted_pointer().

Link: http://lkml.kernel.org/r/1511921105-3647-3-git-send-email-me@tobin.cc
Signed-off-by: Tobin C. Harding <me@tobin.cc>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Fries <cfries@google.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Dave Weinstein <olorin@google.com>
Cc: David Miller <davem@davemloft.net>
Cc: Djalal Harouni <tixxdz@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Ian Campbell <ijc@hellion.org.uk>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jordan Glover <Golden_Miller83@protonmail.ch>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: "Roberts, William C" <william.c.roberts@intel.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Tycho Andersen <tycho@tycho.ws>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   97 ++++++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 43 deletions(-)

diff -puN lib/vsprintf.c~vsprintf-refactor-%pk-code-out-of-pointer lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-refactor-%pk-code-out-of-pointer
+++ a/lib/vsprintf.c
@@ -1343,6 +1343,59 @@ char *uuid_string(char *buf, char *end,
 	return string(buf, end, uuid, spec);
 }
 
+int kptr_restrict __read_mostly;
+
+static noinline_for_stack
+char *restricted_pointer(char *buf, char *end, const void *ptr,
+			 struct printf_spec spec)
+{
+	spec.base = 16;
+	spec.flags |= SMALL;
+	if (spec.field_width == -1) {
+		spec.field_width = 2 * sizeof(ptr);
+		spec.flags |= ZEROPAD;
+	}
+
+	switch (kptr_restrict) {
+	case 0:
+		/* Always print %pK values */
+		break;
+	case 1: {
+		const struct cred *cred;
+
+		/*
+		 * kptr_restrict==1 cannot be used in IRQ context
+		 * because its test for CAP_SYSLOG would be meaningless.
+		 */
+		if (in_irq() || in_serving_softirq() || in_nmi())
+			return string(buf, end, "pK-error", spec);
+
+		/*
+		 * Only print the real pointer value if the current
+		 * process has CAP_SYSLOG and is running with the
+		 * same credentials it started with. This is because
+		 * access to files is checked at open() time, but %pK
+		 * checks permission at read() time. We don't want to
+		 * leak pointer values if a binary opens a file using
+		 * %pK and then elevates privileges before reading it.
+		 */
+		cred = current_cred();
+		if (!has_capability_noaudit(current, CAP_SYSLOG) ||
+		    !uid_eq(cred->euid, cred->uid) ||
+		    !gid_eq(cred->egid, cred->gid))
+			ptr = NULL;
+		break;
+	}
+	case 2:
+	default:
+		/* Always print 0's for %pK */
+		ptr = NULL;
+		break;
+	}
+
+	return number(buf, end, (unsigned long)ptr, spec);
+}
+
 static noinline_for_stack
 char *netdev_bits(char *buf, char *end, const void *addr, const char *fmt)
 {
@@ -1591,8 +1644,6 @@ char *device_node_string(char *buf, char
 	return widen_string(buf, buf - buf_start, end, spec);
 }
 
-int kptr_restrict __read_mostly;
-
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
@@ -1792,47 +1843,7 @@ char *pointer(const char *fmt, char *buf
 			return buf;
 		}
 	case 'K':
-		switch (kptr_restrict) {
-		case 0:
-			/* Always print %pK values */
-			break;
-		case 1: {
-			const struct cred *cred;
-
-			/*
-			 * kptr_restrict==1 cannot be used in IRQ context
-			 * because its test for CAP_SYSLOG would be meaningless.
-			 */
-			if (in_irq() || in_serving_softirq() || in_nmi()) {
-				if (spec.field_width == -1)
-					spec.field_width = default_width;
-				return string(buf, end, "pK-error", spec);
-			}
-
-			/*
-			 * Only print the real pointer value if the current
-			 * process has CAP_SYSLOG and is running with the
-			 * same credentials it started with. This is because
-			 * access to files is checked at open() time, but %pK
-			 * checks permission at read() time. We don't want to
-			 * leak pointer values if a binary opens a file using
-			 * %pK and then elevates privileges before reading it.
-			 */
-			cred = current_cred();
-			if (!has_capability_noaudit(current, CAP_SYSLOG) ||
-			    !uid_eq(cred->euid, cred->uid) ||
-			    !gid_eq(cred->egid, cred->gid))
-				ptr = NULL;
-			break;
-		}
-		case 2:
-		default:
-			/* Always print 0's for %pK */
-			ptr = NULL;
-			break;
-		}
-		break;
