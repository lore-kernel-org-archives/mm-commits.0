Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252E7393DFB
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298503; cv=none; b=PIJThuqWTLcJ0kaZRoVsB0dUFAuXUxZ3id2wnIzUlkKxEeweDbpfSfqDE5zLsZHEJzUPQGc/oatk5yCFUwpexnuVsa2rIcGNA82rcspAQs/UwaS7dmWniCu20+o/cRY41fE61UIFtPksRfY1e3YkKgvoeIMLVkJcgckh6QhaB9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298503; c=relaxed/simple;
	bh=9l1E3GObY4cwh0QNvH3drb2t16VHBVmoJ/PAt5aFknY=;
	h=Date:To:From:Subject:Message-Id; b=N5GlB6KUrH1YDj0wlCd9BSeLrmluKjxKaRv0fwyI5UDp+Ixi0J2p1/w6+12hfdrItwUQptFDqkKkjF98TDcj1irERGSyTPXb65BdxVZpeHy8JdOxVD81ZqTbDWJ+Juz7WBVgvUke7KnImU9smnsE12IrZ8t1ngeC4hVIUzqEqno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OEPMMt4r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OEPMMt4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DEB1F00A3A;
	Wed, 29 Jul 2026 04:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298502;
	bh=SnmHCjH2wkqK0t31+Zp6zvxkLBUG4rkWxg1YONWCX3Q=;
	h=Date:To:From:Subject;
	b=OEPMMt4r/qgoWQjLQYjPPa7i+1/RuAbVaDMiuJ7SKu81ksebTITA8FgiKz0AxgbYc
	 /n4zzjXl53ZIhYPQelRVuWW4rNqZy9wDjlOseeque3J+ArUqTdRN7+PeP1ltSKxeVI
	 Q6oGrEBQqaBs1ZJxnBTnWcAbmvs7mChpB+FnNa6w=
Date: Tue, 28 Jul 2026 21:15:01 -0700
To: mm-commits@vger.kernel.org,yanquanmin1@huawei.com,sj@kernel.org,nathan@kernel.org,morbo@google.com,justinstitt@google.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-reduce-kernel-stack-usage.patch removed from -mm tree
Message-Id: <20260729041501.F1DEB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: reduce kernel stack usage
has been removed from the -mm tree.  Its filename was
     mm-damon-core-reduce-kernel-stack-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm/damon/core: reduce kernel stack usage
Date: Thu, 11 Jun 2026 14:56:57 +0200

The main thread function has recently grown to the point of exceeding
stack frame size warning limits in some configurations.  This is what I
hit on s390 with clang and CONFIG_KASAN:

mm/damon/core.c:3440:31: error: stack frame size (1352) exceeds limit (1280) in 'kdamond_fn' [-Werror,-Wframe-larger-than]
 3440 | static int kdamond_fn(struct damon_ctx *ctx)

The largest stack usage here is inside of the kdamond_tune_intervals(), so
by marking that one as noinline_for_stack, the functions individually stay
below the warning limit, though kdamond_fn() itself still uses hundreds of
kilobytes for some reason.

Link: https://lore.kernel.org/20260611125704.3386176-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-reduce-kernel-stack-usage
+++ a/mm/damon/core.c
@@ -2052,7 +2052,7 @@ static unsigned long damon_get_intervals
 	return adaptation_bp;
 }
 
-static void kdamond_tune_intervals(struct damon_ctx *c)
+static noinline_for_stack void kdamond_tune_intervals(struct damon_ctx *c)
 {
 	unsigned long adaptation_bp;
 	struct damon_attrs new_attrs;
_

Patches currently in -mm which might be from arnd@arndb.de are


