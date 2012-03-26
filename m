From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-max8925c-fix-max8925_rtc_read_alarm-return-value-error.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:31:39 -0700
Message-ID: <20120326193139.5A57AA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:35450 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab2CZTbk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:31:40 -0400
Received: by mail-vx0-f202.google.com with SMTP id fk26so831445vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:31:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kliu5@marvell.com, a.zummo@towertech.it, haojian.zhuang@marvell.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-max8925.c: fix max8925_rtc_read_alarm() return value error
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-max8925c-fix-max8925_rtc_read_alarm-return-value-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Kevin Liu <kliu5@marvell.com>
Subject: drivers/rtc/rtc-max8925.c: fix max8925_rtc_read_alarm() return value error

max8925_rtc_read_alarm should always return 0 with success

Signed-off-by: Kevin Liu <kliu5@marvell.com>
Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max8925.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-max8925.c~drivers-rtc-rtc-max8925c-fix-max8925_rtc_read_alarm-return-value-error drivers/rtc/rtc-max8925.c
--- a/drivers/rtc/rtc-max8925.c~drivers-rtc-rtc-max8925c-fix-max8925_rtc_read_alarm-return-value-error
+++ a/drivers/rtc/rtc-max8925.c
@@ -204,6 +204,7 @@ static int max8925_rtc_read_alarm(struct
 		alrm->pending = 1;
 	else
 		alrm->pending = 0;
+	return 0;
 out:
 	return ret;
 }
_

Patches currently in -mm which might be from kliu5@marvell.com are

origin.patch

