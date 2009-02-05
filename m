From: akpm@linux-foundation.org
Subject: + sysctl-min-max-range-check-is-broken.patch added to -mm tree
Date: Thu, 05 Feb 2009 12:30:08 -0800
Message-ID: <200902052030.n15KU882016797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928AbZBEUan (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 15:30:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shjain@akamai.com, adobriyan@gmail.com, ebiederm@xmission.com, juhlenko@akamai.com


The patch titled
     sysctl: min-max range check is broken
has been added to the -mm tree.  Its filename is
     sysctl-min-max-range-check-is-broken.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

