Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4D9273FC
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247664; cv=none; b=NRIyj8mZ0PabqjvzfcwZVF6swT3tuF+y97aiABAX86FbZc7LrpUDWmJLfLtz3WtHwSwH4VH4JmlZoab3GoPyqwMfr9rG7qjD0oXCwWSvnxxnSjVIPC4SNv9sWzLh2G9ziz7saKtJkXeegjW5Mff3beSYLDTIerXj6i64TiPZEw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247664; c=relaxed/simple;
	bh=2eC98KDisagY7a5joFmYvOXeelekZ1GXUxrZBFWr4cE=;
	h=Date:To:From:Subject:Message-Id; b=M0Qa/EJpoqL/jCNzzOLW0R5kpo3x4pYgRIK+F/2bI39HMbxreTHDoK2WpKr6NVB08vx+HaHWULEQq2Yh/rUs9PkZZ+EfG1E3GAAcopx3RpShbx/kXJbqequ5oa3aLjkZvOdQCzlbNHbmkoAmFEtrZdRpcJFuaAKGz1xUJTunm7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XWeq9UHI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XWeq9UHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48491C4CEC2;
	Mon,  2 Sep 2024 03:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247664;
	bh=2eC98KDisagY7a5joFmYvOXeelekZ1GXUxrZBFWr4cE=;
	h=Date:To:From:Subject:From;
	b=XWeq9UHIlmJM92Ih5AwrbjTkzVzOvaURoCZvx2Oif0Xzf4mcDeapvcmt8aSbb63oK
	 o6NALlBrW+3ZAjo48W3xyAsefRG40f7maEHbLlttBgcCtwimX1aIWoNnqlqAqifg/s
	 tf4Fu7qdX9EDWCaAF4KJt66EihVjDgOkehMr4UiA=
Date: Sun, 01 Sep 2024 20:27:43 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,roman.gushchin@linux.dev,muchun.song@linux.dev,hannes@cmpxchg.org,valdis.kletnieks@vt.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-typo-in-kconfig.patch removed from -mm tree
Message-Id: <20240902032744.48491C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix typo in Kconfig
has been removed from the -mm tree.  Its filename was
     mm-fix-typo-in-kconfig.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Subject: mm: fix typo in Kconfig
Date: Sat, 13 Jul 2024 02:59:50 -0400

Fix typo in Kconfig help

Link: https://lkml.kernel.org/r/78656.1720853990@turing-police
Fixes: e93d4166b40a ("mm: memcg: put cgroup v1-specific code under a config option")
Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/Kconfig~mm-fix-typo-in-kconfig
+++ a/init/Kconfig
@@ -986,7 +986,7 @@ config MEMCG_V1
 	  going to shrink due to deprecation process. New deployments with v1
 	  controller are highly discouraged.
 
-	  San N is unsure.
+	  Say N if unsure.
 
 config BLK_CGROUP
 	bool "IO controller"
_

Patches currently in -mm which might be from valdis.kletnieks@vt.edu are


