From: akpm@osdl.org
Subject: - get_options-to-allow-a-hypenated-range-for-isolcpus.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:04:02 -0800
Message-ID: <200612072304.kB7N42Nr030009@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51974 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163736AbWLGXEH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:04:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dfults@sgi.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     get_options to allow a hypenated range for isolcpus
has been removed from the -mm tree.  Its filename was
     get_options-to-allow-a-hypenated-range-for-isolcpus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: get_options to allow a hypenated range for isolcpus
From: Derek Fults <dfults@sgi.com>

This allows a hyphenated range of positive numbers in the string passed
to command line helper function, get_options.

Currently the command line option "isolcpus=" takes as its argument a
list of cpus.

Format: <cpu number>,...,<cpu number>
Valid values of <cpu_number>  include all cpus, 0 to "number of CPUs in
system - 1". This can get extremely long when isolating the majority of
cpus on a large system.  The kernel isolcpus code would not need any
changing to use this feature.  To use it, the change would be in the
command line format for 'isolcpus='
Format:
<cpu number>,...,<cpu number>
or
<cpu number>-<cpu number>  (must be a positive range in ascending
order.)
or a mixture
<cpu number>,...,<cpu number>-<cpu number>

Signed-off-by: Derek Fults <dfults@sgi.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/kernel-parameters.txt |    7 ++++-
 lib/cmdline.c                       |   35 +++++++++++++++++++++++++-
 2 files changed, 40 insertions(+), 2 deletions(-)

diff -puN Documentation/kernel-parameters.txt~get_options-to-allow-a-hypenated-range-for-isolcpus Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~get_options-to-allow-a-hypenated-range-for-isolcpus
+++ a/Documentation/kernel-parameters.txt
@@ -714,7 +714,12 @@ and is between 256 and 4096 characters. 
 			Format: <RDP>,<reset>,<pci_scan>,<verbosity>
 
 	isolcpus=	[KNL,SMP] Isolate CPUs from the general scheduler.
-			Format: <cpu number>,...,<cpu number>
+			Format:
+			<cpu number>,...,<cpu number>
+			or
+			<cpu number>-<cpu number>  (must be a positive range in ascending order)
+			or a mixture
+			<cpu number>,...,<cpu number>-<cpu number>
 			This option can be used to specify one or more CPUs
 			to isolate from the general SMP balancing and scheduling
 			algorithms. The only way to move a process onto or off
diff -puN lib/cmdline.c~get_options-to-allow-a-hypenated-range-for-isolcpus lib/cmdline.c
--- a/lib/cmdline.c~get_options-to-allow-a-hypenated-range-for-isolcpus
+++ a/lib/cmdline.c
@@ -16,6 +16,23 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 
+/*
+ *	If a hyphen was found in get_option, this will handle the
+ *	range of numbers, M-N.  This will expand the range and insert
+ *	the values[M, M+1, ..., N] into the ints array in get_options.
+ */
+
+static int get_range(char **str, int *pint)
+{
+	int x, inc_counter, upper_range;
+
+	(*str)++;
+	upper_range = simple_strtol((*str), NULL, 0);
+	inc_counter = upper_range - *pint;
+	for (x = *pint; x < upper_range; x++)
+		*pint++ = x;
+	return inc_counter;
+}
 
 /**
  *	get_option - Parse integer from an option string
@@ -29,6 +46,7 @@
  *	0 : no int in string
  *	1 : int found, no subsequent comma
  *	2 : int found including a subsequent comma
+ *	3 : hyphen found to denote a range
  */
 
 int get_option (char **str, int *pint)
@@ -44,6 +62,8 @@ int get_option (char **str, int *pint)
 		(*str)++;
 		return 2;
 	}
+	if (**str == '-')
+		return 3;
 
 	return 1;
 }
@@ -55,7 +75,8 @@ int get_option (char **str, int *pint)
  *	@ints: integer array
  *
  *	This function parses a string containing a comma-separated
- *	list of integers.  The parse halts when the array is
+ *	list of integers, a hyphen-separated range of _positive_ integers,
+ *	or a combination of both.  The parse halts when the array is
  *	full, or when no more numbers can be retrieved from the
  *	string.
  *
@@ -72,6 +93,18 @@ char *get_options(const char *str, int n
 		res = get_option ((char **)&str, ints + i);
 		if (res == 0)
 			break;
+		if (res == 3) {
+			int range_nums;
+			range_nums = get_range((char **)&str, ints + i);
+			if (range_nums < 0)
+				break;
+			/*
+			 * Decrement the result by one to leave out the
+			 * last number in the range.  The next iteration
+			 * will handle the upper number in the range
+			 */
+			i += (range_nums - 1);
+		}
 		i++;
 		if (res == 1)
 			break;
_

Patches currently in -mm which might be from dfults@sgi.com are

origin.patch

