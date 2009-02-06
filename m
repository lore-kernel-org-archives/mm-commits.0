From: akpm@linux-foundation.org
Subject: - sysctl-min-max-range-check-is-broken.patch removed from -mm tree
Date: Fri, 06 Feb 2009 12:26:21 -0800
Message-ID: <200902062026.n16KQLL8012324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136AbZBFU0y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 15:26:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shjain@akamai.com, adobriyan@gmail.com, ebiederm@xmission.com, juhlenko@akamai.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: min-max range check is broken
has been removed from the -mm tree.  Its filename was
     sysctl-min-max-range-check-is-broken.patch

This patch was dropped because im all confused

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: min-max range check is broken
From: Shakesh Jain <shjain@akamai.com>

do_proc_dointvec_minmax_conv() which gets callled from
proc_dointvec_minmax proc_handler doesn't increment the pointer to the
'min' (extra1) and 'max' (extra2) after each range check which results in
doing the check against same set of min and max values.

This breaks the range checking for those sysctl's where you can write
multiple values to /proc with each variable having its own range
specification.

It seems to be implemented for the sysctl() system call strategy in
sysctl_intvec() where min and max are treated as arrays.

Signed-off-by: Shakesh Jain <shjain@akamai.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jason Uhlenkott <juhlenko@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/sysctl.c~sysctl-min-max-range-check-is-broken kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-min-max-range-check-is-broken
+++ a/kernel/sysctl.c
@@ -2411,8 +2411,8 @@ static int do_proc_dointvec_minmax_conv(
 	struct do_proc_dointvec_minmax_conv_param *param = data;
 	if (write) {
 		int val = *negp ? -*lvalp : *lvalp;
-		if ((param->min && *param->min > val) ||
-		    (param->max && *param->max < val))
+		if ((param->min && *(param->min++) > val) ||
+		    (param->max && *(param->max++) < val))
 			return -EINVAL;
 		*valp = val;
 	} else {
_

Patches currently in -mm which might be from shjain@akamai.com are

sysctl-min-max-range-check-is-broken.patch

