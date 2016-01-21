From: akpm@linux-foundation.org
Subject: [merged] fat-allow-time_offset-to-be-upto-24-hours.patch removed
 from -mm tree
Date: Thu, 21 Jan 2016 14:59:28 -0800
Message-ID: <56a162d0.AHLNRb4iJGQiFCSj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbcAUW73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:59:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, hirofumi@mail.parknet.co.jp, list0570@paradise.net.nz, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: allow time_offset to be up to 24 hours
has been removed from the -mm tree.  Its filename was
     fat-allow-time_offset-to-be-upto-24-hours.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fat: allow time_offset to be up to 24 hours

Currently we limit values of time_offset mount option to be between -12
and 12 hours.  However e.g.  zone GMT+12 can have a DST correction on top
which makes the total time difference 13 hours.  Update the checks in
mount option parsing to allow offset of upto 24 hours to allow for unusual
cases.

Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Volker Kuhlmann <list0570@paradise.net.nz>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fat-allow-time_offset-to-be-upto-24-hours fs/fat/inode.c
--- a/fs/fat/inode.c~fat-allow-time_offset-to-be-upto-24-hours
+++ a/fs/fat/inode.c
@@ -1146,7 +1146,12 @@ static int parse_options(struct super_bl
 		case Opt_time_offset:
 			if (match_int(&args[0], &option))
 				return -EINVAL;
-			if (option < -12 * 60 || option > 12 * 60)
+			/*
+			 * GMT+-12 zones may have DST corrections so at least
+			 * 13 hours difference is needed. Make the limit 24
+			 * just in case someone invents something unusual.
+			 */
+			if (option < -24 * 60 || option > 24 * 60)
 				return -EINVAL;
 			opts->tz_set = 1;
 			opts->time_offset = option;
_

Patches currently in -mm which might be from jack@suse.cz are


