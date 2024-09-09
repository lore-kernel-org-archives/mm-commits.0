Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CD818E35E
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925289; cv=none; b=QgZH70G1HuPBVx9QcWhDfaAwqGxm4Qf7C1Vmzda5FevD8B6Ob8yzA29UcAnR3SnmmrDM4siZ6VoWPQrr78UieZYPlLmGqtgmRFVi34VysdNlkDAjbBei9XOSyIDnVkPilN0OlSR+rEMkhb4YN47HpO4F7vPUP0T30JKvcKqnLXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925289; c=relaxed/simple;
	bh=xUy3tNDR5NHbR/hbf4o+hPrm72RXZy7bISKw1R4XerA=;
	h=Date:To:From:Subject:Message-Id; b=Lwam1LQwkgTTj2H5vi+Gr4ayWkWzrHzhawDWh5LVjkUIrOdXNIpPJKjl05XT4jUL60FRWX15jQCGCXD+scR+8OPI91QXV/RgMSAFJGbOAkF+z9XReLmBVbxPP9pwpjUQHkzIVx6bKEO3UqnSOFdLLmpNJC1SLWIUo1MH/ly5v4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IAL0B2gP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IAL0B2gP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2699DC4CEC5;
	Mon,  9 Sep 2024 23:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925289;
	bh=xUy3tNDR5NHbR/hbf4o+hPrm72RXZy7bISKw1R4XerA=;
	h=Date:To:From:Subject:From;
	b=IAL0B2gPeWURP31xxQsJkL0Tl/bTI1ZQeeBsebDTO6+SKJfXdP5CGmwKzCzW7oDUE
	 3gKhP5w9CQoYYqGhSZdcZRpm+TD9IQ+zht34ORPkFVUO0m80n3yElEAotR9ZBwYFJx
	 jouwmh1qM9Fgm47OsT1voKVYf1d95AgPn5O5wgQg=
Date: Mon, 09 Sep 2024 16:41:28 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-support-priority-parameter-in-recompression.patch removed from -mm tree
Message-Id: <20240909234129.2699DC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: support priority parameter in recompression
has been removed from the -mm tree.  Its filename was
     zram-support-priority-parameter-in-recompression.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: support priority parameter in recompression
Date: Mon, 2 Sep 2024 19:56:12 +0900

recompress device attribute supports alg=NAME parameter so that we can
specify only one particular algorithm we want to perform recompression
with.  However, with algo params we now can have several exactly same
secondary algorithms but each with its own params tuning (e.g.  priority 1
configured to use more aggressive level, and priority 2 configured to use
a pre-trained dictionary).  Support priority=NUM parameter so that we can
correctly determine which secondary algorithm we want to use.

Link: https://lkml.kernel.org/r/20240902105656.1383858-25-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |    5 ++++-
 drivers/block/zram/zram_drv.c               |   12 ++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~zram-support-priority-parameter-in-recompression
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -512,11 +512,14 @@ registered compression algorithms, incre
 algorithm that successfully compresses a particular page. Sometimes, however,
 it is convenient (and sometimes even necessary) to limit recompression to
 only one particular algorithm so that it will not try any other algorithms.
-This can be achieved by providing a algo=NAME parameter:::
+This can be achieved by providing a `algo` or `priority` parameter:::
 
 	#use zstd algorithm only (if registered)
 	echo "type=huge algo=zstd" > /sys/block/zramX/recompress
 
+	#use zstd algorithm only (if zstd was registered under priority 1)
+	echo "type=huge priority=1" > /sys/block/zramX/recompress
+
 memory tracking
 ===============
 
--- a/drivers/block/zram/zram_drv.c~zram-support-priority-parameter-in-recompression
+++ a/drivers/block/zram/zram_drv.c
@@ -1855,6 +1855,18 @@ static ssize_t recompress_store(struct d
 			algo = val;
 			continue;
 		}
+
+		if (!strcmp(param, "priority")) {
+			ret = kstrtouint(val, 10, &prio);
+			if (ret)
+				return ret;
+
+			if (prio == ZRAM_PRIMARY_COMP)
+				prio = ZRAM_SECONDARY_COMP;
+
+			prio_max = min(prio + 1, ZRAM_MAX_COMPS);
+			continue;
+		}
 	}
 
 	if (threshold >= huge_class_size)
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-use-unique-zsmalloc-caches-names.patch

