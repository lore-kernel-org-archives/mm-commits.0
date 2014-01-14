From: akpm@linux-foundation.org
Subject: +
 mm-make-creation-of-the-mm_kobj-happen-earlier-than-device_initcall.patch
 added to -mm tree
Date: Tue, 14 Jan 2014 15:55:31 -0800
Message-ID: <52d5ce73.VaESBA6LRXlMQb3x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaANXzc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jan 2014 18:55:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paul.gortmaker@windriver.com

Subject: + mm-make-creation-of-the-mm_kobj-happen-earlier-than-device_initcall.patch added to -mm tree
To: paul.gortmaker@windriver.com
From: akpm@linux-foundation.org
Date: Tue, 14 Jan 2014 15:55:31 -0800


The patch titled
     Subject: mm/mm_init.c: make creation of the mm_kobj happen earlier than device_initcall
has been added to the -mm tree.  Its filename is
     mm-make-creation-of-the-mm_kobj-happen-earlier-than-device_initcall.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-creation-of-the-mm_kobj-happen-earlier-than-device_initcall.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-creation-of-the-mm_kobj-happen-earlier-than-device_initcall.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: mm/mm_init.c: make creation of the mm_kobj happen earlier than device_initcall

The use of __initcall is to be eventually replaced by choosing one from
the prioritized groupings laid out in init.h header:

	pure_initcall               0
	core_initcall               1
	postcore_initcall           2
	arch_initcall               3
	subsys_initcall             4
	fs_initcall                 5
	device_initcall             6
	late_initcall               7

In the interim, all __initcall are mapped onto device_initcall, which as
can be seen above, comes quite late in the ordering.

Currently the mm_kobj is created with __initcall in mm_sysfs_init().  This
means that any other initcalls that want to reference the mm_kobj have to
be device_initcall (or later), otherwise we will for example, trip the
BUG_ON(!kobj) in sysfs's internal_create_group().  This unfairly restricts
those users; for example something that clearly makes sense to be an
arch_initcall will not be able to choose that.

However, upon examination, it is only this way for historical reasons
(i.e.  simply not reprioritized yet).  We see that sysfs is ready quite
earlier in init/main.c via:

 vfs_caches_init
 |_ mnt_init
    |_ sysfs_init

well ahead of the processing of the prioritized calls listed above.

So we can recategorize mm_sysfs_init to be a pure_initcall, which in turn
allows any mm_kobj initcall users a wider range (1 --> 7) of initcall
priorities to choose from.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/mm_init.c~mm-make-creation-of-the-mm_kobj-happen-earlier-than-device_initcall mm/mm_init.c
--- a/mm/mm_init.c~mm-make-creation-of-the-mm_kobj-happen-earlier-than-device_initcall
+++ a/mm/mm_init.c
@@ -202,5 +202,4 @@ static int __init mm_sysfs_init(void)
 
 	return 0;
 }
