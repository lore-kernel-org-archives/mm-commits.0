Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793645952;
	b=5I5cd1ay38O/D/jivWJ8KxlHFI7Q5asQQs61JCZ9tK60Ffsb7OIsXqTPQHoZYCLdgNBn
	 tUhpyqnxpxAmlRRq3o0uTMA0Ccl86By4hypZbnu5Zp7RBfaN3OT+dFtOURf39QTA/CMjm
	 VplOP3mMrdBiuLpA3Vik/yMlXgd6a22HAgTZG8owrHvDH+/eEaELXSN8Dn0lr5vUxWKC/
	 /+Zm3+ueC6X+GZXLgR4djR+ufgVmriTe/RNrgRm5PFZz8eZhwL7azKzfHKkB3ZTTWxZNb
	 2PYGWL0wQQ+0WG+eopkXGzI2PxBJ/YCSJGRZTvCmfDf4bP9/VPE2tnSElbh5YLZ3gVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793645952;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=96LKreaXMlntEzmtxkbqmsh2x2E8Jn1R2laoCZLdONY=;
	b=I2VJ55ZcIcbG8QYjJAg9R0vnhBGQwiSdA4T2QRP+/osrQt8+1CkuK1DQxvbY58gn35eF
	 y8rp8EB4TPImibNwB5dYCcudB6sf1AWoUPnF2vCwfsJxt+n1F6Ql1KkTR8yg9oHkHWup8
	 f9gMmvqD6OGU+wp3DSNRvy53pBlSkkqSLQQfwHAkZOmcz8iCHQStm+9HRXDLgnKs1So0C
	 gek48MEjSX01O6By+XDlB6tze6pAY9KB53AMqJX7buAsblqMS+g0gnRkHPYmNMVLxkwtS
	 MGhF6Jjn4iSU/O/78o3K/iq9bSN40fHS4tKLFLIlAinNQjyFeNcFP/LAnQd/USg1qvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iAysOjIA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C06606A324;
	Mon,  2 Nov 2026 18:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iAysOjIA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162C11F00A16;
	Mon,  2 Nov 2026 18:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793645951;
	bh=96LKreaXMlntEzmtxkbqmsh2x2E8Jn1R2laoCZLdONY=;
	h=Date:To:From:Subject;
	b=iAysOjIA6sObnkEWfBgXTdtqMcvuP7AgNv81zGCA2ELCf8kMs4VIMUuO+X6OyP3lI
	 8OdqdTbljJJPOtt9mHfKfQDyx4Be36kXDTimaCWwlHCpeE/Ak3zHy1+MPvrWilrhsv
	 Ee18fdRdKD77t/Vgcuu8SGe4CIIdnlh0JDceZ7J0=
Date: Mon, 02 Nov 2026 10:59:00 -0800
To: mm-commits@vger.kernel.org,xiaoleiwangxiaolei@gmail.com,
	stable@vger.kernel.org,sj@kernel.org,jm5905938@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-reset-watermark-wait-state-on-each-iteration.patch added to mm-new branch
Message-Id: <20261102185911.162C11F00A16@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/core: reset watermark wait state on each iteration
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-reset-watermark-wait-state-on-each-iteration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-reset-watermark-wait-state-on-each-iteration.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
@@ -3982,10 +3982,11 @@ static int kdamond_wait_activation(struc
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
mm-damon-core-reset-watermark-wait-state-on-each-iteration.patch

