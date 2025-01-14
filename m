Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBD323D3FA
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837151; cv=none; b=Us7zBHV9V/xvLiId7D3UCCM1lZgYBKqvDFryai5lxsymD7FETXsyC7qOnqqL76tkI1tjgUCyIQbdkb7nhz1UCFX4YHjpcUGoIrIxsC2iK6OzGNK3XmO7M3YKcktAeL3ydb8XsfuEeZa5IyC4klWZfwfG34/RXPUUFCqe1RX71kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837151; c=relaxed/simple;
	bh=0kikIpidq/8HqwUtPGWUsH7z/WNrn1yYfM60AWo3pvg=;
	h=Date:To:From:Subject:Message-Id; b=Az9ISlPVnByMnZDW+GV802YdzfXziRxtifToT8Gc1vflYZc4sehkM5BmA7T73I+18aYwHCPNefZoKYo4Z7JRA/nuzg8+5/xyI9sxwO7cU+03kiY+6nXPGZe0rUPlMg150JGDnDE/inl/BSAh5JEW1cSuq180c+BE3MBQXCRfChg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2WyLaL9f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2WyLaL9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748E3C4CEDD;
	Tue, 14 Jan 2025 06:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837151;
	bh=0kikIpidq/8HqwUtPGWUsH7z/WNrn1yYfM60AWo3pvg=;
	h=Date:To:From:Subject:From;
	b=2WyLaL9frYy3STT7XE0cQDn+YZxo/c/Y1SJauLv1WJlR12HRYXDTIgrUHc9qSFLFC
	 r0hY6TN1APqWe8tK2xO+rmaDN4cuBbvLObUz428MV89gz8Es/thtvYrQIPcET+xo4U
	 wKspm9JcTDiH0NsCFlCoQrVyxDdkBqwRXo4Vq0qI=
Date: Mon, 13 Jan 2025 22:45:50 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-use-damon_call-for-update_schemes_effective_quotas.patch removed from -mm tree
Message-Id: <20250114064551.748E3C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: use damon_call() for update_schemes_effective_quotas
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-use-damon_call-for-update_schemes_effective_quotas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: use damon_call() for update_schemes_effective_quotas
Date: Fri, 3 Jan 2025 09:43:56 -0800

DAMON sysfs interface uses damon_callback with its own synchronization
facility to handle update_schemes_effective_quotas command.  But
damon_call() can support the use case without the additional
synchronizations.  Convert the code to use damon_call() instead.

Link: https://lkml.kernel.org/r/20250103174400.54890-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-use-damon_call-for-update_schemes_effective_quotas
+++ a/mm/damon/sysfs.c
@@ -1327,20 +1327,18 @@ static int damon_sysfs_commit_schemes_qu
 /*
  * damon_sysfs_upd_schemes_effective_quotas() - Update schemes effective quotas
  * sysfs files.
- * @kdamond:	The kobject wrapper that associated to the kdamond thread.
+ * @data:	The kobject wrapper that associated to the kdamond thread.
  *
  * This function reads the schemes' effective quotas of specific kdamond and
  * update the related values for sysfs files.  This function should be called
  * from DAMON callbacks while holding ``damon_syfs_lock``, to safely access the
  * DAMON contexts-internal data and DAMON sysfs variables.
  */
-static int damon_sysfs_upd_schemes_effective_quotas(
-		struct damon_sysfs_kdamond *kdamond)
+static int damon_sysfs_upd_schemes_effective_quotas(void *data)
 {
+	struct damon_sysfs_kdamond *kdamond = data;
 	struct damon_ctx *ctx = kdamond->damon_ctx;
 
-	if (!ctx)
-		return -EINVAL;
 	damos_sysfs_update_effective_quotas(
 			kdamond->contexts->contexts_arr[0]->schemes, ctx);
 	return 0;
@@ -1400,9 +1398,6 @@ static int damon_sysfs_cmd_request_callb
 			damon_sysfs_schemes_regions_updating = false;
 		}
 		break;
-	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_EFFECTIVE_QUOTAS:
-		err = damon_sysfs_upd_schemes_effective_quotas(kdamond);
-		break;
 	default:
 		break;
 	}
@@ -1550,6 +1545,10 @@ static int damon_sysfs_handle_cmd(enum d
 	case DAMON_SYSFS_CMD_CLEAR_SCHEMES_TRIED_REGIONS:
 		return damon_sysfs_schemes_clear_regions(
 			kdamond->contexts->contexts_arr[0]->schemes);
+	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_EFFECTIVE_QUOTAS:
+		return damon_sysfs_damon_call(
+				damon_sysfs_upd_schemes_effective_quotas,
+				kdamond);
 	default:
 		break;
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

