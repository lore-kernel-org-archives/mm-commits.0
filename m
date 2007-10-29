From: akpm@linux-foundation.org
Subject: + mips-undo-locking-on-error-path-returns.patch added to -mm tree
Date: Mon, 29 Oct 2007 14:14:20 -0700
Message-ID: <200710292114.l9TLEKoA023539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32860 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197AbXJ2VOb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 17:14:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, ralf@linux-mips.org


The patch titled
     mips: undo locking on error path returns
has been added to the -mm tree.  Its filename is
     mips-undo-locking-on-error-path-returns.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mips: undo locking on error path returns
From: Roel Kluin <12o3l@tiscali.nl>

(akpm: boy. I hope they're privileged operations)

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/irixsig.c    |    1 +
 arch/mips/vr41xx/common/icu.c |    2 ++
 2 files changed, 3 insertions(+)

diff -puN arch/mips/kernel/irixsig.c~mips-undo-locking-on-error-path-returns arch/mips/kernel/irixsig.c
--- a/arch/mips/kernel/irixsig.c~mips-undo-locking-on-error-path-returns
+++ a/arch/mips/kernel/irixsig.c
@@ -426,6 +426,7 @@ asmlinkage int irix_sigprocmask(int how,
 			break;
 
 		default:
+			spin_unlock_irq(&current->sighand->siglock);
 			return -EINVAL;
 		}
 		recalc_sigpending();
diff -puN arch/mips/vr41xx/common/icu.c~mips-undo-locking-on-error-path-returns arch/mips/vr41xx/common/icu.c
--- a/arch/mips/vr41xx/common/icu.c~mips-undo-locking-on-error-path-returns
+++ a/arch/mips/vr41xx/common/icu.c
@@ -525,6 +525,7 @@ static inline int set_sysint1_assign(uns
 		intassign1 |= (uint16_t)assign << 9;
 		break;
 	default:
+		spin_unlock_irq(&desc->lock);
 		return -EINVAL;
 	}
 
@@ -592,6 +593,7 @@ static inline int set_sysint2_assign(uns
 		intassign3 |= (uint16_t)assign << 12;
 		break;
 	default:
+                spin_unlock_irq(&desc->lock);
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
git-arm-master.patch
unlock-when-ssp-tries-to-close-an-invalid-port.patch
dvb-dont-return-with-locks-held.patch
lmc_ioctl-dont-return-with-locks-held.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
git-ocfs2.patch
git-s390.patch
itco_wdt_start-undo-locking-when-reboot-is-disabled.patch
cris-gpio-undo-locks-before-returning.patch
arch-ia64-sn-kernel-mcac-undo-lock-when-sn_oemdata-cant-be-extended.patch
mips-undo-locking-on-error-path-returns.patch
i4l-errors-with-assignments-in-if.patch
