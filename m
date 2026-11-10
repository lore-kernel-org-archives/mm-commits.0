Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293135;
	b=JQUYOUQAN8q4eLKjvy8v/GeRGKi4pjCR/42HEKhXvGohgMWW5ilZbuH+IQwjlJKBWdBa
	 HQ9/veYvY6RIqfaO7WXA836G42n+BFjljnPMaZ82+PvqzWvLm4EJDEgb7fJ0U3JJcYq3y
	 lNZ6jNVOlqh1UFQhULQF9jG6jUBTHRy7NfflILIaOpgpqYTS5ztxF7r8rdBhIbE2O8d39
	 0qCvmNCfoxuOOTwCVvzPbZ1WRZdVFBNckAJx4ulJXxu6vlIaguTDAO8QNXN+aR7nchq37
	 UegBiKsr0mLNyHcZA3TI0c/fNlTlO0DpCKnn3FVSbTNUhZvLjpN12lnZ4/eTYSPcKBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293135;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=oJwXeSol4ObpGTz/6GVgMNSfZi+nUC7w4jOdgOTyP38=;
	b=yDqj9yoFy6gNfUUOCYijJIzlgcQb2kii2i+hRGOGgvbVic0LD+ff4dDfnNv7yTGAMn9P
	 eWL+fx9t0vZx2WqwjatWWyQNMNK8LuZMjXQYuNzEvoyOqWPrXhV10k82TUu2Ld358LU1d
	 oBkgIJRwGA4cbXAAQwofgo0E3zDjrRFKD9bQWaBslK8SCkuFT5XsQxf3eZROT81698Ze2
	 5ok4DfMC1Ur3lSXd1j2rJa6eXxKd1bbsQemvFUK3VyVy1MvEAzV5Fb1HQkPsdDa8h7v3u
	 654WGjlHq5n7Qtl0vNqERFuyuJs1ZeBgOskVQQCImwpqvzAXqCk2yJKahnrKvBaaTig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="dESA6K/m";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000A1606CB30;
	Tue, 10 Nov 2026 06:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dESA6K/m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCFFB1F008A2;
	Tue, 10 Nov 2026 06:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293134;
	bh=oJwXeSol4ObpGTz/6GVgMNSfZi+nUC7w4jOdgOTyP38=;
	h=Date:To:From:Subject;
	b=dESA6K/mVkEaNv2Bm/5eGs4e9zVeRGo34nhLtGEuNAR37ijjBftPKYlHa8yc9c6Gw
	 N3YdYQ7w97YX5VJlUDbp4KNc7L/IC7XibYRlUfXxrb914qHUDrG3miLxlCQ4d9NCd9
	 BJXhUKm5i31lTDWpTj0lTzGN55V8glpI4Pk+lBC4=
Date: Mon, 09 Nov 2026 22:45:34 -0800
To: mm-commits@vger.kernel.org,xiaoleiwangxiaolei@gmail.com,
	stable@vger.kernel.org,sj@kernel.org,jm5905938@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-reset-watermark-wait-state-on-each-iteration.patch removed from -mm tree
Message-Id: <20261110064534.BCFFB1F008A2@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/damon/core: reset watermark wait state on each iteration
has been removed from the -mm tree.  Its filename was
     mm-damon-core-reset-watermark-wait-state-on-each-iteration.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Aveline Noir <jm5905938@gmail.com>
Subject: mm/damon/core: reset watermark wait state on each iteration
Date: Mon, 02 Nov 2026 06:46:24 -0800

Patch series "mm/damon: fix watermark state, kunit pid leak and selftest
fake pass".

Three hotfixes for core, kunit and selftest.  Fix kdamond deactivation
from missed watermark reset with patch 1.  Fix pid leak in kunit test
with patch 2.  Fix a selftest wrongly passing when it should skip, with
patch 3.

Note for reviewers.  This series is a collection of fixes that were
initially developed by different people.  Changelog is in each patch.


This patch (of 3):

Found while reviewing the DAMON source code that if an online commit
removes all schemes while kdamond is waiting for watermark activation,
the scheme loop becomes empty but min_wait_time keeps the previous
positive value.  kdamond then keeps sleeping instead of resuming
monitoring without schemes.

The way to wake up the kdamond again without DAMON is bit complicated.
Install a scheme having watermarks that can activate the kdamond again,
and remove the scheme again.  Doable but cumbersome and complicated.

Initialize min_wait_time and init_wait_time on each loop iteration so
the wait is calculated from the current schemes and an empty scheme
list resumes monitoring.

Link: https://lore.kernel.org/20261102144627.88843-1-sj@kernel.org
Link: https://lore.kernel.org/20261102144627.88843-2-sj@kernel.org
Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Wang Xiaolei <xiaoleiwangxiaolei@gmail.com>
Cc: <stable@vger.kernel.org> # 5.19.x
---

 mm/damon/core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-reset-watermark-wait-state-on-each-iteration
+++ a/mm/damon/core.c
@@ -3976,10 +3976,11 @@ static int kdamond_wait_activation(struc
 {
 	struct damos *s;
 	unsigned long wait_time;
-	unsigned long min_wait_time = 0;
-	bool init_wait_time = false;
 
 	while (!kdamond_need_stop(ctx)) {
+		unsigned long min_wait_time = 0;
+		bool init_wait_time = false;
+
 		damon_for_each_scheme(s, ctx) {
 			wait_time = damos_wmark_wait_us(s);
 			if (!init_wait_time || wait_time < min_wait_time) {
_

Patches currently in -mm which might be from jm5905938@gmail.com are

mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pmd-young-bit.patch
mm-damon-stat-avoid-32-bit-overflow-in-idle-percentiles.patch
mm-damon-pvaddr-skip-folios-already-on-the-migration-target-node.patch
docs-admin-guide-mm-damon-start-fix-grammar.patch
docs-admin-guide-mm-damon-stat-fix-pronoun-agreement.patch
docs-admin-guide-mm-damon-usage-fix-grammar.patch
docs-admin-guide-mm-damon-lru_sort-fix-remaining-grammar.patch
docs-mm-damon-design-fix-grammar-and-typos.patch
docs-mm-damon-api-fix-verb-form.patch
docs-mm-damon-maintainer-profile-fix-subject-verb-agreement.patch
docs-mm-damon-monitoring_intervals_tuning_example-fix-grammar-and-typos.patch

