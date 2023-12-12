Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5409B80029
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jhg88wlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF3AC433C9;
	Tue, 12 Dec 2023 18:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407572;
	bh=UXKXfWzGwyVRKqfhh/Qm9WI7Oy/6ODPsooFNNZibKd0=;
	h=Date:To:From:Subject:From;
	b=jhg88wlQHxTCB4fUHBJV5vA24jtdn4bBctbvmfQLhvk4wVRI1thHxoaTpYgu5MHMq
	 R/IWtpbizgqxomfdLpTF0Vyky2U5xL+nz3gj+lT0tAPOxS2Na83NdsGIg1HWYDMgw5
	 IVBxBktQAY3TgfMqKZebDRzLIUX9C2WtM+oBP/BA=
Date: Tue, 12 Dec 2023 10:59:31 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,corbet@lwn.net,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-implement-a-command-for-scheme-quota-goals-only-commit.patch removed from -mm tree
Message-Id: <20231212185932.1AF3AC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: implement a command for scheme quota goals only commit
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-implement-a-command-for-scheme-quota-goals-only-commit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: implement a command for scheme quota goals only commit
Date: Thu, 30 Nov 2023 02:36:47 +0000

To update DAMOS quota goals, users need to enter 'commit' command to the
'state' file of the kdamond, which applies not only the goals but entire
inputs.  It is inefficient.  Implement yet another 'state' file input
command for reading and committing only the scheme quota goals, namely
'commit_schemes_quota_goals'.

Link: https://lkml.kernel.org/r/20231130023652.50284-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-common.h  |    3 +++
 mm/damon/sysfs-schemes.c |   16 ++++++++++++++++
 mm/damon/sysfs.c         |   27 +++++++++++++++++++++++++++
 3 files changed, 46 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-schemes-implement-a-command-for-scheme-quota-goals-only-commit
+++ a/mm/damon/sysfs.c
@@ -995,6 +995,11 @@ enum damon_sysfs_cmd {
 	/* @DAMON_SYSFS_CMD_COMMIT: Update kdamond inputs. */
 	DAMON_SYSFS_CMD_COMMIT,
 	/*
+	 * @DAMON_SYSFS_CMD_COMMIT_SCHEMES_QUOTA_GOALS: Commit the quota goals
+	 * to DAMON.
+	 */
+	DAMON_SYSFS_CMD_COMMIT_SCHEMES_QUOTA_GOALS,
+	/*
 	 * @DAMON_SYSFS_CMD_UPDATE_SCHEMES_STATS: Update scheme stats sysfs
 	 * files.
 	 */
@@ -1025,6 +1030,7 @@ static const char * const damon_sysfs_cm
 	"on",
 	"off",
 	"commit",
+	"commit_schemes_quota_goals",
 	"update_schemes_stats",
 	"update_schemes_tried_bytes",
 	"update_schemes_tried_regions",
@@ -1351,6 +1357,24 @@ static int damon_sysfs_commit_input(stru
 			kdamond->contexts->contexts_arr[0]);
 }
 
+static int damon_sysfs_commit_schemes_quota_goals(
+		struct damon_sysfs_kdamond *sysfs_kdamond)
+{
+	struct damon_ctx *ctx;
+	struct damon_sysfs_context *sysfs_ctx;
+
+	if (!damon_sysfs_kdamond_running(sysfs_kdamond))
+		return -EINVAL;
+	/* TODO: Support multiple contexts per kdamond */
+	if (sysfs_kdamond->contexts->nr != 1)
+		return -EINVAL;
+
+	ctx = sysfs_kdamond->damon_ctx;
+	sysfs_ctx = sysfs_kdamond->contexts->contexts_arr[0];
+	damos_sysfs_set_quota_scores(sysfs_ctx->schemes, ctx);
+	return 0;
+}
+
 /*
  * damon_sysfs_cmd_request_callback() - DAMON callback for handling requests.
  * @c:		The DAMON context of the callback.
@@ -1379,6 +1403,9 @@ static int damon_sysfs_cmd_request_callb
 	case DAMON_SYSFS_CMD_COMMIT:
 		err = damon_sysfs_commit_input(kdamond);
 		break;
+	case DAMON_SYSFS_CMD_COMMIT_SCHEMES_QUOTA_GOALS:
+		err = damon_sysfs_commit_schemes_quota_goals(kdamond);
+		break;
 	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_BYTES:
 		total_bytes_only = true;
 		fallthrough;
--- a/mm/damon/sysfs-common.h~mm-damon-sysfs-schemes-implement-a-command-for-scheme-quota-goals-only-commit
+++ a/mm/damon/sysfs-common.h
@@ -56,3 +56,6 @@ int damon_sysfs_schemes_update_regions_s
 int damon_sysfs_schemes_clear_regions(
 		struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx);
+
+void damos_sysfs_set_quota_scores(struct damon_sysfs_schemes *sysfs_schemes,
+		struct damon_ctx *ctx);
--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-a-command-for-scheme-quota-goals-only-commit
+++ a/mm/damon/sysfs-schemes.c
@@ -1896,6 +1896,22 @@ static void damos_sysfs_set_quota_score(
 	}
 }
 
+void damos_sysfs_set_quota_scores(struct damon_sysfs_schemes *sysfs_schemes,
+		struct damon_ctx *ctx)
+{
+	struct damos *scheme;
+	int i = 0;
+
+	damon_for_each_scheme(scheme, ctx) {
+		struct damon_sysfs_scheme *sysfs_scheme;
+
+		sysfs_scheme = sysfs_schemes->schemes_arr[i];
+		damos_sysfs_set_quota_score(sysfs_scheme->quotas->goals,
+				&scheme->quota);
+		i++;
+	}
+}
+
 static struct damos *damon_sysfs_mk_scheme(
 		struct damon_sysfs_scheme *sysfs_scheme)
 {
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-make-damon_start-waits-until-kdamond_fn-starts.patch

