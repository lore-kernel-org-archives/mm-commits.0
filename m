From: akpm@linux-foundation.org
Subject: - cpufreq-document-the-currently-undocumented-parts-of-the-sysfs-interface.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:50:57 -0700
Message-ID: <200804300550.m3U5ovhA030170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753840AbYD3F4m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:56:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, davej@codemonkey.org.uk, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     cpufreq: document the currently undocumented parts of the sysfs interface
has been removed from the -mm tree.  Its filename was
     cpufreq-document-the-currently-undocumented-parts-of-the-sysfs-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-hwmon.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
adt7473-minor-documentation-update.patch

