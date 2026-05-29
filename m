Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3170B371CE4
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028737; cv=none; b=q6x8O5ZfZKZ6aqU9dwomlomnJ/QN15xHZMsuDyZvW8rHEJNCmfVi9MbsBsrT8AoGODWASUc3oCg9nu6aDRiYT2ZZKk5tw9IY4Hw0VPgIQZqZAmR4ub5EasRxhEz6zz/dMGnoIIrM0+Vg5lq1b8rNlwo0wuYdZ33mzjZrtE/+i3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028737; c=relaxed/simple;
	bh=w0+sZK+Yu6zXEhjL21nU81Lq8UlwKzrMBbP6AWluCG4=;
	h=Date:To:From:Subject:Message-Id; b=ehyf3fH8c8wLD7tqqEdu+SRPWxM9oIEA/2ZULEEVizM6XzMNa5FzDrfm/kTGC2q2hwxXDddjVjjLz6jW8iRa99V4B+UHHMNgr1I6io0IrzoNCkxp+87mfSczDA+whdFohpFKsxNeMKRXXFW5xaJeLRwufhzbsLFjveWt7ihbUGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dCyDU3jI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dCyDU3jI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F581F00898;
	Fri, 29 May 2026 04:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028735;
	bh=cXBmnOcydZB0Hdpx2D5Yx9nK3I96NDYq6DE7CfpM1K8=;
	h=Date:To:From:Subject;
	b=dCyDU3jIjDRYCviQoA9PsPKxxMYSdgHHuZE0En5GR3FdEVOM78eVJy5lfh9ZZvZwH
	 R9IiPM4i9At5RnTla7/JYRogcd8a7Jj2unEarualYpEdmblchNyiJ5VbuVr4Ohjm0A
	 bbEn4XO1meKymDYvszeUheKZp+8LCUtE3Jj+s6qY=
Date: Thu, 28 May 2026 21:25:35 -0700
To: mm-commits@vger.kernel.org,wang.yaxin@zte.com.cn,fan.yu9@zte.com.cn,cyyzero16@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] tools-accounting-getdelays-fix-wformat-truncation-warning-in-format_timespec.patch removed from -mm tree
Message-Id: <20260529042535.B8F581F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/accounting/getdelays: fix -Wformat-truncation warning in format_timespec
has been removed from the -mm tree.  Its filename was
     tools-accounting-getdelays-fix-wformat-truncation-warning-in-format_timespec.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yiyang Chen <cyyzero16@gmail.com>
Subject: tools/accounting/getdelays: fix -Wformat-truncation warning in format_timespec
Date: Thu, 23 Apr 2026 23:11:39 +0800

Reproduce with GCC 13.3.0:

  $ cd tools/accounting
  $ make

This emits:

getdelays.c: In function `format_timespec':
getdelays.c:218:67: warning: `:' directive output may be truncated writing 1 byte into a region of size between 0 and 16 [-Wformat-truncation=]
  218 |         snprintf(buffer, sizeof(buffer), "%04d-%02d-%02dT%02d:%02d:%02d",
      |
getdelays.c:218:9: note: `snprintf' output between 20 and 72 bytes into a destination of size 32

The problem is that %04d and %02d specify minimum field widths only. GCC
cannot prove that formatting tm_year + 1900 and the other struct tm
fields will always fit in the fixed 32-byte buffer, so it warns about
possible truncation.

Fix this by replacing the manual snprintf() formatting with
strftime("%Y-%m-%dT%H:%M:%S", ...). That matches the data we already have
in struct tm, keeps the intended timestamp format, and avoids the warning
when building tools/accounting with GCC.

Link: https://lore.kernel.org/87d9723e0b59d816ee2e4bd7cddd58a54c6c9f91.1776956545.git.cyyzero16@gmail.com
Signed-off-by: Yiyang Chen <cyyzero16@gmail.com>
Cc: Fan Yu <fan.yu9@zte.com.cn>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/accounting/getdelays.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/tools/accounting/getdelays.c~tools-accounting-getdelays-fix-wformat-truncation-warning-in-format_timespec
+++ a/tools/accounting/getdelays.c
@@ -241,13 +241,7 @@ static const char *format_timespec(struc
 	if (localtime_r(&time_sec, &tm_info) == NULL)
 		return "N/A";
 
-	snprintf(buffer, sizeof(buffer), "%04d-%02d-%02dT%02d:%02d:%02d",
-		tm_info.tm_year + 1900,
-		tm_info.tm_mon + 1,
-		tm_info.tm_mday,
-		tm_info.tm_hour,
-		tm_info.tm_min,
-		tm_info.tm_sec);
+	strftime(buffer, sizeof(buffer), "%Y-%m-%dT%H:%M:%S", &tm_info);
 
 	return buffer;
 }
_

Patches currently in -mm which might be from cyyzero16@gmail.com are


