From: akpm@linux-foundation.org
Subject: [merged]
 uidgid-make-uid_valid-and-gid_valid-work-with-config_multiuser.patch
 removed from -mm tree
Date: Mon, 18 May 2015 11:44:19 -0700
Message-ID: <555a3303.nm1cWTGYXDmG5dX+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbbERSoT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 May 2015 14:44:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@joshtriplett.org, fengguang.wu@intel.com, peter@hurleysoftware.com, mm-commits@vger.kernel.org


The patch titled
     Subject: uidgid: make uid_valid and gid_valid work with !CONFIG_MULTIUSER
has been removed from the -mm tree.  Its filename was
     uidgid-make-uid_valid-and-gid_valid-work-with-config_multiuser.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: uidgid: make uid_valid and gid_valid work with !CONFIG_MULTIUSER

{u,g}id_valid call {u,g}id_eq, which calls __k{u,g}id_val on both
arguments and compares.  With !CONFIG_MULTIUSER, __k{u,g}id_val return a
constant 0, which makes {u,g}id_valid always return false.  Change
{u,g}id_valid to compare their argument against -1 instead.  That produces
identical results in the normal CONFIG_MULTIUSER=y case, but with
!CONFIG_MULTIUSER will make {u,g}id_valid constant-fold into "return
true;" rather than "return false;".

This fixes uses of devpts without CONFIG_MULTIUSER.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>,
Cc: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uidgid.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/uidgid.h~uidgid-make-uid_valid-and-gid_valid-work-with-config_multiuser include/linux/uidgid.h
--- a/include/linux/uidgid.h~uidgid-make-uid_valid-and-gid_valid-work-with-config_multiuser
+++ a/include/linux/uidgid.h
@@ -109,12 +109,12 @@ static inline bool gid_lte(kgid_t left,
 
 static inline bool uid_valid(kuid_t uid)
 {
-	return !uid_eq(uid, INVALID_UID);
+	return __kuid_val(uid) != (uid_t) -1;
 }
 
 static inline bool gid_valid(kgid_t gid)
 {
-	return !gid_eq(gid, INVALID_GID);
+	return __kgid_val(gid) != (gid_t) -1;
 }
 
 #ifdef CONFIG_USER_NS
_

Patches currently in -mm which might be from josh@joshtriplett.org are

clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic.patch
clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix.patch
clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix-2.patch
x86-opt-into-have_copy_thread_tls-for-both-32-bit-and-64-bit.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
linux-next.patch

