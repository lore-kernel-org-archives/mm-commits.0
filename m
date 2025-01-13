Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5C01F9F40
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 23:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736809898; cv=none; b=lp42FKd/LFodD7MXmZ0FyWO90grrKhxXGECug+d2jPIHckiuRM4u5zYQbGAsK3sClfyBv/I6F7Km69wyDvPcaacs+Ft/LGPLyVvMJfJtpq+JmMP2pNM6l0O2MJRx00ayGp1rNooQ19+GGc+DdxT9VQfSw91+4K33TtLmVxaumo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736809898; c=relaxed/simple;
	bh=1GzBp48yOa5Cm3zHzGTGVfRM+kx5Ihr3NKQ0XqviKkw=;
	h=Date:To:From:Subject:Message-Id; b=GbmsZbQclqaO6U3ybPO0r37JtkPTy73dvF41d56IlCVRm5Dz7ZwAY3v1wsGHxv9hN3L+h4W24wcMLL3P6LWcoxcZCQ69Q5Xk8tDGN7NvRL+rXhsOW8ABYSIZPXETXMQclZGlH2Lpy38p0OSfWuCxUztlD8JVSm3N8/1BxJzcCwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rkoPFUr+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rkoPFUr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F08C4CED6;
	Mon, 13 Jan 2025 23:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736809897;
	bh=1GzBp48yOa5Cm3zHzGTGVfRM+kx5Ihr3NKQ0XqviKkw=;
	h=Date:To:From:Subject:From;
	b=rkoPFUr+5pUVDpCm05n78pjHfF+e510fYaEbEyokmMx0BY6JWUN4SJ4A7uk0f8Z9+
	 3/31oxIBA49kw1R9kd2Gn/7utwyYtoDHg+GXSKqDWfDgBahA9Hpat+gvSkibKUMXhD
	 jxSVHLv48mtBZOzXOku9h0ey0bNdtICGf/43vUeU=
Date: Mon, 13 Jan 2025 15:11:37 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,mszeredi@redhat.com,josef@toxicpanda.com,jefflexu@linux.alibaba.com,bernd.schubert@fastmail.fm,joannelkoong@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-migrate-skip-migrating-folios-under-writeback-with-as_writeback_indeterminate-mappings.patch removed from -mm tree
Message-Id: <20250113231137.B7F08C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: skip migrating folios under writeback with AS_WRITEBACK_INDETERMINATE mappings
has been removed from the -mm tree.  Its filename was
     mm-migrate-skip-migrating-folios-under-writeback-with-as_writeback_indeterminate-mappings.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Joanne Koong <joannelkoong@gmail.com>
Subject: mm/migrate: skip migrating folios under writeback with AS_WRITEBACK_INDETERMINATE mappings
Date: Fri, 22 Nov 2024 15:23:58 -0800

For migrations called in MIGRATE_SYNC mode, skip migrating the folio if it
is under writeback and has the AS_WRITEBACK_INDETERMINATE flag set on its
mapping.  If the AS_WRITEBACK_INDETERMINATE flag is set on the mapping,
the writeback may take an indeterminate amount of time to complete, and
waits may get stuck.

Link: https://lkml.kernel.org/r/20241122232359.429647-5-joannelkoong@gmail.com
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Jingbo Xu <jefflexu@linux.alibaba.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-skip-migrating-folios-under-writeback-with-as_writeback_indeterminate-mappings
+++ a/mm/migrate.c
@@ -1254,7 +1254,10 @@ static int migrate_folio_unmap(new_folio
 		 */
 		switch (mode) {
 		case MIGRATE_SYNC:
-			break;
+			if (!src->mapping ||
+			    !mapping_writeback_indeterminate(src->mapping))
+				break;
+			fallthrough;
 		default:
 			rc = -EBUSY;
 			goto out;
_

Patches currently in -mm which might be from joannelkoong@gmail.com are

fuse-remove-tmp-folio-for-writebacks-and-internal-rb-tree.patch

