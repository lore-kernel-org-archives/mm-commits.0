Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1673A79C5
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739414; cv=none; b=Jm71ty0h01pNMmwjOw28mWpx0dIrtwByRkfH9P5Ya7qGvGj7fr9Tp5vUuEKak+U2w76kD7D0FgBhbj/NiA+YfvWWdnJJAppIWVM6sJ/wGH+7jZJYtHO3gppXOM9Hv5PD5TeNYO7Gitw5dGeR2Q7Pc3oGVbvbtXGGvh7VBSGb9fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739414; c=relaxed/simple;
	bh=pK9vXdroRyIxGd2TZWMcCuafExKiTUAKgIZ5FvnHcrI=;
	h=Date:To:From:Subject:Message-Id; b=RD97z//QlaNiu3kexdwKBm8Xf5seREEmw4400gCUaQJdnQNQpFWTnl1kHiuz80URUFXmw/xioqrfHtVYaeSnYBQD5LgCKPYW9UdMwHqOaj403+kB1uzNvmv3dIIEQ25ltjAAf9eE/iDEbD3kA3+JV9QPqdLWA7QxcU4cWklBFN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UzbaWXt7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UzbaWXt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907B6C433F1;
	Sat, 24 Feb 2024 01:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739413;
	bh=pK9vXdroRyIxGd2TZWMcCuafExKiTUAKgIZ5FvnHcrI=;
	h=Date:To:From:Subject:From;
	b=UzbaWXt743A8DNe4qcpRB/3jwwMQcl/e2i7zha0bPlzYaZb3bPRshPeZG2yNsNcf/
	 8ThGly+DdXiYYnHtmftmWquW2T2qlJbBn+1ceP84CiqRVBn0nCz+UFT/hoLaA7AaTn
	 pddX6eVwlDnCf+S0ssSwsuhI2E3zt0cEvmWvn3i4=
Date: Fri, 23 Feb 2024 17:50:13 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-implement-a-kdamond-command-for-updating-schemes-effective-quotas.patch removed from -mm tree
Message-Id: <20240224015013.907B6C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: implement a kdamond command for updating schemes' effective quotas
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-implement-a-kdamond-command-for-updating-schemes-effective-quotas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: implement a kdamond command for updating schemes' effective quotas
Date: Mon, 19 Feb 2024 11:44:14 -0800

Implement yet another kdamond 'state' file input command, namely
'update_schemes_effective_quotas'.  If it is written, the
'effective_bytes' files of the kdamond will be updated to provide the
current effective size quota of each scheme in bytes.

Link: https://lkml.kernel.org/r/20240219194431.159606-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-common.h  |    4 ++++
 mm/damon/sysfs-schemes.c |   20 ++++++++++++++++++++
 mm/damon/sysfs.c         |   32 ++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-implement-a-kdamond-command-for-updating-schemes-effective-quotas
+++ a/mm/damon/sysfs.c
@@ -1020,6 +1020,11 @@ enum damon_sysfs_cmd {
 	 */
 	DAMON_SYSFS_CMD_CLEAR_SCHEMES_TRIED_REGIONS,
 	/*
+	 * @DAMON_SYSFS_CMD_UPDATE_SCHEMES_EFFECTIVE_QUOTAS: Update the
+	 * effective size quota of the scheme in bytes.
+	 */
+	DAMON_SYSFS_CMD_UPDATE_SCHEMES_EFFECTIVE_QUOTAS,
+	/*
 	 * @NR_DAMON_SYSFS_CMDS: Total number of DAMON sysfs commands.
 	 */
 	NR_DAMON_SYSFS_CMDS,
@@ -1035,6 +1040,7 @@ static const char * const damon_sysfs_cm
 	"update_schemes_tried_bytes",
 	"update_schemes_tried_regions",
 	"clear_schemes_tried_regions",
+	"update_schemes_effective_quotas",
 };
 
 /*
@@ -1376,6 +1382,29 @@ static int damon_sysfs_commit_schemes_qu
 }
 
 /*
+ * damon_sysfs_upd_schemes_effective_quotas() - Update schemes effective quotas
+ * sysfs files.
+ * @kdamond:	The kobject wrapper that associated to the kdamond thread.
+ *
+ * This function reads the schemes' effective quotas of specific kdamond and
+ * update the related values for sysfs files.  This function should be called
+ * from DAMON callbacks while holding ``damon_syfs_lock``, to safely access the
+ * DAMON contexts-internal data and DAMON sysfs variables.
+ */
+static int damon_sysfs_upd_schemes_effective_quotas(
+		struct damon_sysfs_kdamond *kdamond)
+{
+	struct damon_ctx *ctx = kdamond->damon_ctx;
+
+	if (!ctx)
+		return -EINVAL;
+	damos_sysfs_update_effective_quotas(
+			kdamond->contexts->contexts_arr[0]->schemes, ctx);
+	return 0;
+}
+
+
+/*
  * damon_sysfs_cmd_request_callback() - DAMON callback for handling requests.
  * @c:		The DAMON context of the callback.
  * @active:	Whether @c is not deactivated due to watermarks.
@@ -1437,6 +1466,9 @@ static int damon_sysfs_cmd_request_callb
 	case DAMON_SYSFS_CMD_CLEAR_SCHEMES_TRIED_REGIONS:
 		err = damon_sysfs_clear_schemes_regions(kdamond);
 		break;
+	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_EFFECTIVE_QUOTAS:
+		err = damon_sysfs_upd_schemes_effective_quotas(kdamond);
+		break;
 	default:
 		break;
 	}
--- a/mm/damon/sysfs-common.h~mm-damon-sysfs-implement-a-kdamond-command-for-updating-schemes-effective-quotas
+++ a/mm/damon/sysfs-common.h
@@ -61,3 +61,7 @@ int damon_sysfs_schemes_clear_regions(
 
 void damos_sysfs_set_quota_scores(struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx);
+
+void damos_sysfs_update_effective_quotas(
+		struct damon_sysfs_schemes *sysfs_schemes,
+		struct damon_ctx *ctx);
--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-implement-a-kdamond-command-for-updating-schemes-effective-quotas
+++ a/mm/damon/sysfs-schemes.c
@@ -1930,6 +1930,26 @@ void damos_sysfs_set_quota_scores(struct
 	}
 }
 
+void damos_sysfs_update_effective_quotas(
+		struct damon_sysfs_schemes *sysfs_schemes,
+		struct damon_ctx *ctx)
+{
+	struct damos *scheme;
+	int schemes_idx = 0;
+
+	damon_for_each_scheme(scheme, ctx) {
+		struct damon_sysfs_quotas *sysfs_quotas;
+
+		/* user could have removed the scheme sysfs dir */
+		if (schemes_idx >= sysfs_schemes->nr)
+			break;
+
+		sysfs_quotas =
+			sysfs_schemes->schemes_arr[schemes_idx++]->quotas;
+		sysfs_quotas->effective_sz = scheme->quota.esz;
+	}
+}
+
 static struct damos *damon_sysfs_mk_scheme(
 		struct damon_sysfs_scheme *sysfs_scheme)
 {
_

Patches currently in -mm which might be from sj@kernel.org are


