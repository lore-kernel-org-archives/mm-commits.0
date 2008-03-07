From: akpm@linux-foundation.org
Subject: - my-halt-pfn-regression.patch removed from -mm tree
Date: Fri, 07 Mar 2008 12:49:02 -0800
Message-ID: <200803072049.m27Kn3PH016569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932132AbYCGUth (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 15:49:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     my `halt -pfn' regression
has been removed from the -mm tree.  Its filename was
     my-halt-pfn-regression.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: my `halt -pfn' regression
From: "Rafael J. Wysocki" <rjw@sisk.pl>

On Wednesday, 5 of March 2008, Andrew Morton wrote:
> On Wed, 5 Mar 2008 01:14:20 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
> > On Tuesday, 4 of March 2008, Andrew Morton wrote:
> > >
> > > The 8-way x86_64 box still won't poweroff in -rc3.  Disabling
> > > CONFIG_DETECT_SOFTLOCKUP "fixes" it.
> >
> > Well, we have bug #9960 with similar symptoms, but that's supposed to be
> > fixed in -rc3.
> >
> > There also is bug #10169 that may be related.
> >
> > > With the full -mm lineup, the machine won't power off during `halt -p' even
> > > with CONFIG_DETECT_SOFTLOCKUP=n, so we're going backwards.
> >
> > I'd bet on the CPU hotplug ...
> >
> > Please try to remove the disable_nonboot_cpus() from the power off code path.
>
> Like this?
>
> --- a/kernel/power/main.c~a
> +++ a/kernel/power/main.c
> @@ -282,7 +282,7 @@ int suspend_devices_and_enter(suspend_st
>  	if (suspend_test(TEST_PLATFORM))
>  		goto Finish;
>
> -	error = disable_nonboot_cpus();
> +	error = 0;
>  	if (!error && !suspend_test(TEST_CPUS))
>  		suspend_enter(state);

No, I meant this one:

---
 1 file changed, 1 deletion(-)

Index: linux-2.6/kernel/sys.c
===================================================================

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/sys.c~my-halt-pfn-regression kernel/sys.c
--- a/kernel/sys.c~my-halt-pfn-regression
+++ a/kernel/sys.c
@@ -347,7 +347,6 @@ void kernel_power_off(void)
 	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
 	if (pm_power_off_prepare)
 		pm_power_off_prepare();
-	disable_nonboot_cpus();
 	sysdev_shutdown();
 	printk(KERN_EMERG "Power down.\n");
 	machine_power_off();
_

Patches currently in -mm which might be from rjw@sisk.pl are

my-halt-pfn-regression.patch
git-acpi.patch
time-dont-touch-an-offlined-cpus-ts-tick_stopped-in-tick_cancel_sched_timer.patch
power-replace-remaining-__function__-occurrences.patch
shrink_slab-handle-bad-shrinkers.patch

