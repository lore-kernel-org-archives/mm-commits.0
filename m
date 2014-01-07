From: akpm@linux-foundation.org
Subject: + audit-correct-a-type-mismatch-in-audit_syscall_exit.patch added to -mm tree
Date: Tue, 07 Jan 2014 15:29:22 -0800
Message-ID: <52cc8dd2.qFnjHuPBoF/zYD6X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbaAGX3X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jan 2014 18:29:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, stable@vger.kernel.org, eparis@redhat.com, takahiro.akashi@linaro.org

Subject: + audit-correct-a-type-mismatch-in-audit_syscall_exit.patch added to -mm tree
To: takahiro.akashi@linaro.org,eparis@redhat.com,stable@vger.kernel.org,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 07 Jan 2014 15:29:22 -0800


The patch titled
     Subject: audit: correct a type mismatch in audit_syscall_exit()
has been added to the -mm tree.  Its filename is
     audit-correct-a-type-mismatch-in-audit_syscall_exit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/audit-correct-a-type-mismatch-in-audit_syscall_exit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/audit-correct-a-type-mismatch-in-audit_syscall_exit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: audit: correct a type mismatch in audit_syscall_exit()

audit_syscall_exit() saves a result of regs_return_value() in intermediate
"int" variable and passes it to __audit_syscall_exit(), which expects its
second argument as a "long" value.  This will result in truncating the
value returned by a system call and making a wrong audit record.

I don't know why gcc compiler doesn't complain about this, but anyway it
causes a problem at runtime on arm64 (and probably most 64-bit archs).

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/audit.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/audit.h~audit-correct-a-type-mismatch-in-audit_syscall_exit include/linux/audit.h
--- a/include/linux/audit.h~audit-correct-a-type-mismatch-in-audit_syscall_exit
+++ a/include/linux/audit.h
@@ -137,7 +137,7 @@ static inline void audit_syscall_exit(vo
 {
 	if (unlikely(current->audit_context)) {
 		int success = is_syscall_success(pt_regs);
-		int return_code = regs_return_value(pt_regs);
+		long return_code = regs_return_value(pt_regs);
 
 		__audit_syscall_exit(success, return_code);
 	}
_

Patches currently in -mm which might be from takahiro.akashi@linaro.org are

audit-correct-a-type-mismatch-in-audit_syscall_exit.patch

