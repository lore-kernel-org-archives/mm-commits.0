From: akpm@linux-foundation.org
Subject: - profile-likely-unlikely-macros-x86_64-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:20:57 -0800
Message-ID: <200703060220.l262KvWA009289@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47410 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965752AbXCFCVG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:21:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, johnstul@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     profile-likely-unlikely-macros x86_64 fix
has been removed from the -mm tree.  Its filename was
     profile-likely-unlikely-macros-x86_64-fix.patch

This patch was dropped because it was folded into profile-likely-unlikely-macros.patch

------------------------------------------------------
Subject: profile-likely-unlikely-macros x86_64 fix
From: Daniel Walker <dwalker@mvista.com>

On Sun, 2006-12-31 at 23:04 +0800, Fengguang Wu wrote:
> Hi,
>
> The following messages keeps popping up when CONFIG_PROFILE_LIKELY=y:
>
> init[1]: segfault at ffffffff8118c110 rip ffffffff8118c110 rsp 00007fff9a9d14d8 error 15
> init[1]: segfault at ffffffff8118c110 rip ffffffff8118c110 rsp 00007fff9a9d14d8 error 15
> init[1]: segfault at ffffffff8118c110 rip ffffffff8118c110 rsp 00007fff9a9d14d8 error 15
> init[1]: segfault at ffffffff8118c110 rip ffffffff8118c110 rsp 00007fff9a9d14d8 error 15
> init[1]: segfault at ffffffff8118c110 rip ffffffff8118c110 rsp 00007fff9a9d14d8 error 15
> init[1]: segfault at ffffffff8118c110 rip ffffffff8118c110 rsp 00007fff9a9d14d8 error 15
> init[1]: segfault at ffffffff8118c110 rip ffffffff8118c110 rsp 00007fff9a9d14d8 error 15
> init[1]: segfault at ffffffff8118c110 rip ffffffff8118c110 rsp 00007fff9a9d14d8 error 15
>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Acked-by: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/vsyscall.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/kernel/vsyscall.c~profile-likely-unlikely-macros-x86_64-fix arch/x86_64/kernel/vsyscall.c
--- a/arch/x86_64/kernel/vsyscall.c~profile-likely-unlikely-macros-x86_64-fix
+++ a/arch/x86_64/kernel/vsyscall.c
@@ -111,7 +111,7 @@ static __always_inline void do_vgettimeo
 		seq = read_seqbegin(&__vsyscall_gtod_data.lock);
 
 		vread = __vsyscall_gtod_data.clock.vread;
-		if (unlikely(!__vsyscall_gtod_data.sysctl_enabled || !vread)) {
+		if (!__vsyscall_gtod_data.sysctl_enabled || !vread) {
 			gettimeofday(tv,0);
 			return;
 		}
@@ -151,7 +151,7 @@ int __vsyscall(0) vgettimeofday(struct t
  * unlikely */
 time_t __vsyscall(1) vtime(time_t *t)
 {
-	if (unlikely(!__vsyscall_gtod_data.sysctl_enabled))
+	if (!__vsyscall_gtod_data.sysctl_enabled)
 		return time_syscall(t);
 	else if (t)
 		*t = __vsyscall_gtod_data.wall_time_tv.tv_sec;
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
slim-make-and-config-stuff.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-x86_64-fix.patch
