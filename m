Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819638F7A
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739416; cv=none; b=lmTwzx2ZgaDI3hXjM+U1XiDb37jrFVANyhpGodQIgvEVrLzLBPsJ/VRNxUhv+wD/V/tN53qZEVsoJbpL98Bv+Tpocx6tOl5VhVnuNthMD6NVv3muoHof2uWsdR8go5bVikGzSgrU7zCwygwNXDvv/UQai1iB4gMVmprB0B6e1oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739416; c=relaxed/simple;
	bh=qp9JxO3KjIM6e/gxELxHrHjkq28/4Ayp5phUNRmdA8I=;
	h=Date:To:From:Subject:Message-Id; b=oMqunr9UN1VoorzpSfyP6Go2h1dAv9ttYmBwy5LsFYixtLFN8aRZFqSfmyOs22e2a7w7asyiMU5NSmHLAoxwksl7R94PUdc2G/VMws8AOFT6ZVq81eM87BNJ/oBatVM03OGUOigBKoU5cRSckC/L3oxj+ghZAh3ULO1n092C2HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=piVGldtn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="piVGldtn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57AE7C433F1;
	Sat, 24 Feb 2024 01:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739416;
	bh=qp9JxO3KjIM6e/gxELxHrHjkq28/4Ayp5phUNRmdA8I=;
	h=Date:To:From:Subject:From;
	b=piVGldtncnc3dEl0heEsYQKAgwhGn5oF9X7KcS7JJT2T7vZ/FiYDjw8YmO0ka0RmK
	 85h6jGHQqtIYAD7AiS3VO4YcHPz2sDlFD3zh6043ed3xy/v1DGMWJvMOJS9a9oPo0X
	 1Kfs8GCxidHrbPGxssszEQvYuYniy/SE733vDVgo=
Date: Fri, 23 Feb 2024 17:50:15 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-move-comments-and-fields-for-damos-quota-prioritization-to-the-end.patch removed from -mm tree
Message-Id: <20240224015016.57AE7C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: move comments and fields for damos-quota-prioritization to the end
has been removed from the -mm tree.  Its filename was
     mm-damon-move-comments-and-fields-for-damos-quota-prioritization-to-the-end.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: move comments and fields for damos-quota-prioritization to the end
Date: Mon, 19 Feb 2024 11:44:17 -0800

The comments and definition of 'struct damos_quota' lists a few fields for
effective quota generation first, fields for regions prioritization under
the quota, and then remaining fields for effective quota generation. 
Readers' should unnecesssarily switch their context in the middle.  List
all the fields for the effective quota first, and then fields for the
prioritization for making it easier to read.

Link: https://lkml.kernel.org/r/20240219194431.159606-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/include/linux/damon.h~mm-damon-move-comments-and-fields-for-damos-quota-prioritization-to-the-end
+++ a/include/linux/damon.h
@@ -128,18 +128,17 @@ enum damos_action {
 
 /**
  * struct damos_quota - Controls the aggressiveness of the given scheme.
+ * @reset_interval:	Charge reset interval in milliseconds.
  * @ms:			Maximum milliseconds that the scheme can use.
  * @sz:			Maximum bytes of memory that the action can be applied.
- * @reset_interval:	Charge reset interval in milliseconds.
+ * @get_score:		Feedback function for self-tuning quota.
+ * @get_score_arg:	Parameter for @get_score
+ * @esz:		Effective size quota in bytes.
  *
  * @weight_sz:		Weight of the region's size for prioritization.
  * @weight_nr_accesses:	Weight of the region's nr_accesses for prioritization.
  * @weight_age:		Weight of the region's age for prioritization.
  *
- * @get_score:		Feedback function for self-tuning quota.
- * @get_score_arg:	Parameter for @get_score
- * @esz:		Effective size quota in bytes.
- *
  * To avoid consuming too much CPU time or IO resources for applying the
  * &struct damos->action to large memory, DAMON allows users to set time and/or
  * size quotas.  The quotas can be set by writing non-zero values to &ms and
@@ -152,12 +151,6 @@ enum damos_action {
  * throughput of the scheme's action.  DAMON then compares it against &sz and
  * uses smaller one as the effective quota.
  *
- * For selecting regions within the quota, DAMON prioritizes current scheme's
- * target memory regions using the &struct damon_operations->get_scheme_score.
- * You could customize the prioritization logic by setting &weight_sz,
- * &weight_nr_accesses, and &weight_age, because monitoring operations are
- * encouraged to respect those.
- *
  * If @get_score function pointer is set, DAMON calls it back with
  * @get_score_arg and get the return value of it for every @reset_interval.
  * Then, DAMON adjusts the effective quota using the return value as a feedback
@@ -170,20 +163,25 @@ enum damos_action {
  * set, the mechanism starts from the quota of one byte.
  *
  * The resulting effective size quota in bytes is set to @esz.
+ *
+ * For selecting regions within the quota, DAMON prioritizes current scheme's
+ * target memory regions using the &struct damon_operations->get_scheme_score.
+ * You could customize the prioritization logic by setting &weight_sz,
+ * &weight_nr_accesses, and &weight_age, because monitoring operations are
+ * encouraged to respect those.
  */
 struct damos_quota {
+	unsigned long reset_interval;
 	unsigned long ms;
 	unsigned long sz;
-	unsigned long reset_interval;
+	unsigned long (*get_score)(void *arg);
+	void *get_score_arg;
+	unsigned long esz;
 
 	unsigned int weight_sz;
 	unsigned int weight_nr_accesses;
 	unsigned int weight_age;
 
-	unsigned long (*get_score)(void *arg);
-	void *get_score_arg;
-	unsigned long esz;
-
 /* private: */
 	/* For throughput estimation */
 	unsigned long total_charged_sz;
_

Patches currently in -mm which might be from sj@kernel.org are


