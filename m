Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D05215777
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188262; cv=none; b=qSPMDbDr5CDEMcGiUU/gjnuVUDH2HFlEoW5h7tHrlluidI8kwQZxExjGeTDJt77esvpL0ML0Kdoof/UF3wZwPnpzYXEHXwv1eNhhp+79A/Z9EcxYThX7KFPxdKblTs9OQg4WIp39/XNM77e2JzK0Kotq4678qOXGPokKLHW6O64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188262; c=relaxed/simple;
	bh=xPZ01VW2YA5rG4Xhn1CqBCKeWOB3fFNCwNSmG/DS4i0=;
	h=Date:To:From:Subject:Message-Id; b=X1w1MOrZ4FA/ZWXNZHeTweIOEGog6YtywTacSXjSU/dJ/eljhZJpTajw9b+kNTjMAHuPgV+gA4e+hZKQE2bhGVmm/GgxIXm3KSkLWN04wg+ffglE4oycZ79f2ZflLLj8fPumklFTCfnFIK2Qe+1Agx1nUgrNlE0bUXDaVCyw0us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z4OAjVBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z4OAjVBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD7CC4CEEC;
	Mon, 17 Mar 2025 05:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188262;
	bh=xPZ01VW2YA5rG4Xhn1CqBCKeWOB3fFNCwNSmG/DS4i0=;
	h=Date:To:From:Subject:From;
	b=z4OAjVBNqYOwJyCuTCgax98KyaQ+sIHAVwqJtDzCttJBD694w+IbpNP1sCp6D7LEF
	 mtVQ/bzyKfRHc97ALt4I+NJqQZLUfz5waGJZBqMo6huocvBizd88Q6HcQnlnSYU7JD
	 IPxqVmQVeTkEBWAzZBB7W8OoFEhEgAUCayAXk1hQ=
Date: Sun, 16 Mar 2025 22:11:01 -0700
To: mm-commits@vger.kernel.org,howlett@gmail.com,richard120310@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-correct-comment-for-mas_start.patch removed from -mm tree
Message-Id: <20250317051101.ECD7CC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: correct comment for mas_start()
has been removed from the -mm tree.  Its filename was
     maple_tree-correct-comment-for-mas_start.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: I Hsin Cheng <richard120310@gmail.com>
Subject: maple_tree: correct comment for mas_start()
Date: Mon, 10 Feb 2025 02:10:23 +0800

There's no mas->status of "mas_start", what the function is checking is
whether mas->status equals to "ma_start".  Correct the comment for the
function.

Link: https://lkml.kernel.org/r/20250209181023.228856-1-richard120310@gmail.com
Signed-off-by: I Hsin Cheng <richard120310@gmail.com>
Reviewed-by: Liam R. Howlett <howlett@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-correct-comment-for-mas_start
+++ a/lib/maple_tree.c
@@ -1353,7 +1353,7 @@ static void mas_node_count(struct ma_sta
  * mas_start() - Sets up maple state for operations.
  * @mas: The maple state.
  *
- * If mas->status == mas_start, then set the min, max and depth to
+ * If mas->status == ma_start, then set the min, max and depth to
  * defaults.
  *
  * Return:
_

Patches currently in -mm which might be from richard120310@gmail.com are

lib-plistc-add-shortcut-for-plist_requeue.patch

