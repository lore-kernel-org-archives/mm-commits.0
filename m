From: akpm@linux-foundation.org
Subject: [merged] udf-fix-novrs-mount-option.patch removed from -mm tree
Date: Thu, 12 Mar 2009 13:17:14 -0700
Message-ID: <200903122017.n2CKHEmh032650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751393AbZCLUU0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Mar 2009 16:20:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clemens@ladisch.de, jack@ucw.cz, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     udf: fix novrs mount option
has been removed from the -mm tree.  Its filename was
     udf-fix-novrs-mount-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: udf: fix novrs mount option
From: Clemens Ladisch <clemens@ladisch.de>

The novrs mount option was broken due to a missing break.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Cc: Jan Kara <jack@ucw.cz>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/super.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/udf/super.c~udf-fix-novrs-mount-option fs/udf/super.c
--- a/fs/udf/super.c~udf-fix-novrs-mount-option
+++ a/fs/udf/super.c
@@ -439,6 +439,7 @@ static int udf_parse_options(char *optio
 		switch (token) {
 		case Opt_novrs:
 			uopt->novrs = 1;
+			break;
 		case Opt_bs:
 			if (match_int(&args[0], &option))
 				return 0;
_

Patches currently in -mm which might be from clemens@ladisch.de are

linux-next.patch

