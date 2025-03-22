Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB077081C
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742620251; cv=none; b=XeGYZ4b1AqUWiI3fyURzQFLTcWjUZ77AgPgbRT1NWwUiUyUnKNmJA5Lwrpy5VX5FHY5tq461QjJuZCBz89Uo3BDTiYgDdw3NaB0+9i0s/E846YKSBYEuYa0LagC0Kc02ezQbsRewTADTmxc1jDz7gce/E9+qCPX58oHOLWcbnKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742620251; c=relaxed/simple;
	bh=WSDN5lnyErtuzepoCGGSWDZ9Yhy4WDYzYIRFyA/jPEA=;
	h=Date:To:From:Subject:Message-Id; b=eOcjY9MCeAGlblX4QnfsfkvbhPHNIBzLq4hK1z4cZEG5xq5CnH9+23tusaRBQ9JbyzjeHkasSkHhT7zz1w/KprabjfRWqcxtNCiyDOV1gvhC0zMz0rxJTh4xZ5uY8B8hntdloX5fmgy+OM4QJeECCizLQOTxuZ/7c1GJa3pjDBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y5rzE58p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y5rzE58p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A560C4CEDD;
	Sat, 22 Mar 2025 05:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742620251;
	bh=WSDN5lnyErtuzepoCGGSWDZ9Yhy4WDYzYIRFyA/jPEA=;
	h=Date:To:From:Subject:From;
	b=y5rzE58pMMXMqThgK8hwrCqVrzlB2sDl2RYlvhoT8lOdpB3ZAZsdNOe7tzcbkSwfR
	 UFmYpS8USszjVlo66ctwcia4gjgqS7SVbnEm+UX5YOAtWvQNUlghw53ZQbB9Mm7iDB
	 g550Sf0+DG5o+5jIFChcYddH9GjZDuI0FTCFJDlc=
Date: Fri, 21 Mar 2025 22:10:50 -0700
To: mm-commits@vger.kernel.org,ilpo.jarvinen@linux.intel.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] resource-replace-open-coded-variants-of-define_res__named.patch removed from -mm tree
Message-Id: <20250322051051.1A560C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: resource: replace open coded variants of DEFINE_RES_*_NAMED()
has been removed from the -mm tree.  Its filename was
     resource-replace-open-coded-variants-of-define_res__named.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: resource: replace open coded variants of DEFINE_RES_*_NAMED()
Date: Mon, 17 Mar 2025 20:11:12 +0200

Replace open coded variants of DEFINE_RES_*_NAMED().

Link: https://lkml.kernel.org/r/20250317181412.1560630-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/kernel/resource.c~resource-replace-open-coded-variants-of-define_res__named
+++ a/kernel/resource.c
@@ -1714,18 +1714,13 @@ static int __init reserve_setup(char *st
 			 * I/O port space; otherwise assume it's memory.
 			 */
 			if (io_start < 0x10000) {
-				res->flags = IORESOURCE_IO;
+				*res = DEFINE_RES_IO_NAMED(io_start, io_num, "reserved");
 				parent = &ioport_resource;
 			} else {
-				res->flags = IORESOURCE_MEM;
+				*res = DEFINE_RES_MEM_NAMED(io_start, io_num, "reserved");
 				parent = &iomem_resource;
 			}
-			res->name = "reserved";
-			res->start = io_start;
-			res->end = io_start + io_num - 1;
 			res->flags |= IORESOURCE_BUSY;
-			res->desc = IORES_DESC_NONE;
-			res->child = NULL;
 			if (request_resource(parent, res) == 0)
 				reserved = x+1;
 		}
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


