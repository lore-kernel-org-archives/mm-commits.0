From: akpm@linux-foundation.org
Subject: + cpufreq-document-the-currently-undocumented-parts-of-the-sysfs-interface.patch added to -mm tree
Date: Fri, 21 Mar 2008 17:00:46 -0700
Message-ID: <200803220000.m2M00kl0017503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752782AbYCVABp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 20:01:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, davej@codemonkey.org.uk, venkatesh.pallipadi@intel.com


The patch titled
     cpufreq: document the currently undocumented parts of the sysfs interface
has been added to the -mm tree.  Its filename is
     cpufreq-document-the-currently-undocumented-parts-of-the-sysfs-interface.patch

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
Subject: cpufreq: document the currently undocumented parts of the sysfs interface
From: "Darrick J. Wong" <djwong@us.ibm.com>

There is a description of some of the sysfs files.  However, there are some
that are not mentioned in the documentation, so add them to the user's guide.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpu-freq/user-guide.txt |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN Documentation/cpu-freq/user-guide.txt~cpufreq-document-the-currently-undocumented-parts-of-the-sysfs-interface Documentation/cpu-freq/user-guide.txt
--- a/Documentation/cpu-freq/user-guide.txt~cpufreq-document-the-currently-undocumented-parts-of-the-sysfs-interface
+++ a/Documentation/cpu-freq/user-guide.txt
@@ -154,6 +154,11 @@ scaling_governor,		and by "echoing" the 
 				that some governors won't load - they only
 				work on some specific architectures or
 				processors.
+
+cpuinfo_cur_freq :		Current speed of the CPU, in KHz.
+
+scaling_available_frequencies : List of available frequencies, in KHz.
+
 scaling_min_freq and
 scaling_max_freq		show the current "policy limits" (in
 				kHz). By echoing new values into these
@@ -162,6 +167,15 @@ scaling_max_freq		show the current "poli
 				first set scaling_max_freq, then
 				scaling_min_freq.
 
+affected_cpus :			List of CPUs that require software coordination
+				of frequency.
+
+related_cpus :			List of CPUs that need some sort of frequency
+				coordination, whether software or hardware.
+
+scaling_driver :		Hardware driver for cpufreq.
+
+scaling_cur_freq :		Current frequency of the CPU, in KHz.
 
 If you have selected the "userspace" governor which allows you to
 set the CPU operating frequency to a specific value, you can read out
_

Patches currently in -mm which might be from djwong@us.ibm.com are

origin.patch
cpufreq-expose-cpufreq-coordination-requirements-regardless-of-coordination-mechanism.patch
cpufreq-document-the-currently-undocumented-parts-of-the-sysfs-interface.patch
git-hwmon.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
git-scsi-misc.patch
mptbase-reset-ioc-initiator-during-pci-resume.patch
scsi-aic94xx-cleanups.patch

