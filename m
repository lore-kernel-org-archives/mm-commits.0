From: akpm@linux-foundation.org
Subject: + drivers-cpufreq-add-calls-to-cpufreq_cpu_put.patch added to -mm tree
Date: Tue, 15 Jan 2008 01:35:00 -0800
Message-ID: <200801150934.m0F9Yec3009054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55939 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198AbYAOJey (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 04:34:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, davej@codemonkey.org.uk


The patch titled
     drivers/cpufreq: add calls to cpufreq_cpu_put
has been added to the -mm tree.  Its filename is
     drivers-cpufreq-add-calls-to-cpufreq_cpu_put.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/cpufreq: add calls to cpufreq_cpu_put
From: Julia Lawall <julia@diku.dk>


A call to cpufreq_cpu_get should be matched by a call to cpufreq_cpu_put.

The problem was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
identifier E;
expression E1, E2;
int ret;
statement S;
@@

  T E;
  ... when any
(
  E = cpufreq_cpu_get(...);
  if (E == NULL) S
|
  if ((E = cpufreq_cpu_get(...)) == NULL) S
)
  ... when != E2 = E
      when strict
(
  cpufreq_cpu_put(E);
|
  E1 = E;
|
+ cpufreq_cpu_put(E);
  return;
|
+ cpufreq_cpu_put(E);
  return ret;
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/cpufreq/cpufreq.c~drivers-cpufreq-add-calls-to-cpufreq_cpu_put drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~drivers-cpufreq-add-calls-to-cpufreq_cpu_put
+++ a/drivers/cpufreq/cpufreq.c
@@ -676,8 +676,10 @@ static ssize_t show(struct kobject * kob
 	if (!policy)
 		return -EINVAL;
 
-	if (lock_policy_rwsem_read(policy->cpu) < 0)
+	if (lock_policy_rwsem_read(policy->cpu) < 0) {
+		cpufreq_cpu_put(policy);
 		return -EINVAL;
+	}
 
 	if (fattr->show)
 		ret = fattr->show(policy, buf);
@@ -700,8 +702,10 @@ static ssize_t store(struct kobject * ko
 	if (!policy)
 		return -EINVAL;
 
-	if (lock_policy_rwsem_write(policy->cpu) < 0)
+	if (lock_policy_rwsem_write(policy->cpu) < 0) {
+		cpufreq_cpu_put(policy);
 		return -EINVAL;
+	}
 
 	if (fattr->store)
 		ret = fattr->store(policy, buf, count);
_

Patches currently in -mm which might be from julia@diku.dk are

git-alsa.patch
git-agpgart.patch
drivers-cpufreq-add-calls-to-cpufreq_cpu_put.patch
git-powerpc.patch
arch-powerpc-platforms-pseries-add-missing-of_node_put.patch
arch-powerpc-sysdev-add-missing-of_node_put.patch
arch-powerpc-platforms-82xx-add-missing-of_node_put.patch
drivers-media-radio-use-video_device_release-rather-than-kfree.patch
drivers-media-common-add-missing-video_device_release.patch
git-input.patch
git-mtd.patch
git-net.patch
drivers-pcmcia-add-missing-iounmap.patch
drivers-pcmcia-add-missing-pci_dev_get.patch
git-x86.patch
arch-cris-added-a-missing-iounmap.patch
drivers-video-remove-unnecessary-pci_dev_put.patch
drivers-video-add-missing-pci_dev_get.patch
