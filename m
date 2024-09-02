Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED6C18733B
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 21:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725311948; cv=none; b=bJ2uuaujrvoEjEhTRFEOswgTtjzKZYCkeRk76pgIyV5CYqlO8L0qfk1qsg/y2UQF5oHC+uhkyP76VrqAXRl5TmaGjq1LFjhFNnecoqGpPM4Ze2htQWBsbtQyNxaDqUOZLyd8AKWAinNOmwGryiCdfugg4R18KgEXvlNgIVmPggU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725311948; c=relaxed/simple;
	bh=7BEkKcQtaMXTWr6Si2OStioaYTwsWStb+6Gmfw3+AQ4=;
	h=Date:To:From:Subject:Message-Id; b=ij36u1Ei1dYvUTkk8Xbzz1Cjpn48xjREL9NE4pjDTuCD0O7msX2u7Bp8gKP37m9LainQroYWzrVyoj3tVq1JVQDFTsW5He0l5MoSB56FBn9X1eoy6guFSAh4nlt2mLWYt8Vx3rcAAknWKl8ZhIctoAm4BUX69eMMaCH9uK0TpTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2liosnjO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2liosnjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D13C4CEC2;
	Mon,  2 Sep 2024 21:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725311948;
	bh=7BEkKcQtaMXTWr6Si2OStioaYTwsWStb+6Gmfw3+AQ4=;
	h=Date:To:From:Subject:From;
	b=2liosnjOpTf7sN1nyEpbxJpsF+WR4kiPutefuuDjd2QVnvnBUo3H8xFYy+MAfMEUz
	 tw0uId6Hen2x3x+gjLA7pgnuoEhJIpxaUxYPh0Ncpzw771MlkXMHe+zwX5/3/ZAJVq
	 7IbhRJcAGDfTlq8SIRYrPzPaAOEBTXd60rjWCmDQ=
Date: Mon, 02 Sep 2024 14:19:08 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-support-priority-parameter-in-recompression.patch added to mm-unstable branch
Message-Id: <20240902211908.82D13C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: support priority parameter in recompression
has been added to the -mm mm-unstable branch.  Its filename is
     zram-support-priority-parameter-in-recompression.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-support-priority-parameter-in-recompression.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

lib-zstd-export-api-needed-for-dictionary-support.patch
lib-lz4hc-export-lz4_resetstreamhc-symbol.patch
lib-zstd-fix-null-deref-in-zstd_createcdict_advanced2.patch
zram-introduce-custom-comp-backends-api.patch
zram-add-lzo-and-lzorle-compression-backends-support.patch
zram-add-lz4-compression-backend-support.patch
zram-add-lz4hc-compression-backend-support.patch
zram-add-zstd-compression-backend-support.patch
zram-pass-estimated-src-size-hint-to-zstd.patch
zram-add-zlib-compression-backend-support.patch
zram-add-842-compression-backend-support.patch
zram-check-that-backends-array-has-at-least-one-backend.patch
zram-introduce-zcomp_params-structure.patch
zram-recalculate-zstd-compression-params-once.patch
zram-introduce-algorithm_params-device-attribute.patch
zram-add-support-for-dict-comp-config.patch
zram-introduce-zcomp_req-structure.patch
zram-introduce-zcomp_ctx-structure.patch
zram-move-immutable-comp-params-away-from-per-cpu-context.patch
zram-add-dictionary-support-to-lz4.patch
zram-add-dictionary-support-to-lz4hc.patch
zram-add-dictionary-support-to-zstd-backend.patch
documentation-zram-add-documentation-for-algorithm-parameters.patch
zram-support-priority-parameter-in-recompression.patch

