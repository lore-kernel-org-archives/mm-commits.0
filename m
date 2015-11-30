From: akpm@linux-foundation.org
Subject: + fat-allow-time_offset-to-be-upto-24-hours.patch added to -mm
 tree
Date: Mon, 30 Nov 2015 14:26:29 -0800
Message-ID: <565ccd15.JQfXIt9HsKDQ33Ls%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59953 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbbK3W0a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Nov 2015 17:26:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, hirofumi@mail.parknet.co.jp, list0570@paradise.net.nz, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: allow time_offset to be up to 24 hours
has been added to the -mm tree.  Its filename is
     fat-allow-time_offset-to-be-upto-24-hours.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-allow-time_offset-to-be-upto-24-hours.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fat-allow-time_offset-to-be-upto-24-hours.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fat-allow-time_offset-to-be-upto-24-hours.patch

