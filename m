From: akpm@linux-foundation.org
Subject: - mips-undo-locking-on-error-path-returns.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:10:34 -0800
Message-ID: <200711152110.lAFLAYtj015665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40403 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932243AbXKOVRN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips: undo locking on error path returns
has been removed from the -mm tree.  Its filename was
     mips-undo-locking-on-error-path-returns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mips: undo locking on error path returns
From: Roel Kluin <12o3l@tiscali.nl>

[akpm@linux-foundation.org: coding-style cleanups]
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
@@ -430,6 +430,7 @@ asmlinkage int irix_sigprocmask(int how,
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
+		spin_unlock_irq(&desc->lock);
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
unlock-when-ssp-tries-to-close-an-invalid-port.patch
git-dvb.patch
git-mips.patch
git-netdev-all.patch
sound-oss-tridentc-fix-incorrect-test-in-trident_ac97_set.patch
