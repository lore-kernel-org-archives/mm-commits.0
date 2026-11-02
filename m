Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793645963;
	b=pvTk6R5GE3A2F8KCr9/csvVyWa3USkp4XJeeWedzyckSfiPEe6VTTVZoQzu2954pz2MA
	 ZrfB7XTbuoqAR5N3221kQI7G1SiuRZx6rQI7pcEO6AfVMu8mv+ytZ1yP4O8ddSc/PQ0ls
	 ciOXy6mfFFXQ2hD0qd1Q7aFLaZPdZrykobX0xPAXHRwcxjSll7cKjnn+EeWBPiJK0UQwr
	 LeOCVB3+QxrEoGcwk/ZJM0uK0t4KsS3WKCckjhuv8s2giSBcZywf0CQiBXScbujY7VRTS
	 HYsyakzhc6PGmfhopt6tXU0em8adCa+tFKPvA4UNhZafxTydfnegcxw/wIxgQFLl4ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793645963;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=5mRtPrKiTj1NJfBurVT+6eR+VCtcqV1JQpewnXNZ3cg=;
	b=aESWaB5l78lUwQqLRPvHzVsrDOuzt88tLRVbnjnEiCcsdRYY46u9Z13Mq9PNDAgQVuZD
	 Ouxm2BxWr673hmnUXHZegF67MyqC3cJy7cfM/zxvzgydvvPvhlXqfjdoR15jhJZXLw5Wm
	 jjOGNdpnCXeVf9brwIZqB+5X/4S58LmYVD5wn+DxtxFzG3QX0oSb28Iw64iYk1yBuatGj
	 kgd/VrYh1g35kxqmAFqdUGkWLGcP/fG1hWt5Cx14fmqW99NilkAMXn0NHvKoA96deQAGG
	 gvGbSPp+29iyWaeQTIiHQD8tWYgcwgZx2MomJsBV3VPyB2PpFB2sXBNA9Ic6061Y2gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NOKZgW1s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FE9606A32C;
	Mon,  2 Nov 2026 18:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NOKZgW1s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7D61F00A17;
	Mon,  2 Nov 2026 18:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793645962;
	bh=5mRtPrKiTj1NJfBurVT+6eR+VCtcqV1JQpewnXNZ3cg=;
	h=Date:To:From:Subject;
	b=NOKZgW1sjkpQYKELqiWvyyrVt/mnJU8xdVOai76a9hvJqh3SFSz5Yjhu88L8JfDs6
	 Vb0D+d10k9cq9kSYCOMf6ek1mt8A1/WEGoUxsOCB49yiVywqMTCKzMIBoBHIPz/XFw
	 ZU+B2q55wwXk1+WhisgG5B1EASCMRys4G7Bb6UYk=
Date: Mon, 02 Nov 2026 10:59:12 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	stable@vger.kernel.org,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,
	liam@infradead.org,jm5905938@gmail.com,davidgow@davidgow.net,
	brendan.higgins@linux.dev,xiaoleiwangxiaolei@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-sysfs-kunit-fix-leaked-pid-reference-in-add_targets-test.patch added to mm-new branch
Message-Id: <20261102185922.BA7D61F00A17@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/tests/sysfs-kunit: fix leaked pid reference in add_targets test
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-sysfs-kunit-fix-leaked-pid-reference-in-add_targets-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-sysfs-kunit-fix-leaked-pid-reference-in-add_targets-test.patch

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
From: Wang Xiaolei <xiaoleiwangxiaolei@gmail.com>
Subject: mm/damon/tests/sysfs-kunit: fix leaked pid reference in add_targets test
Date: Mon, 02 Nov 2026 06:46:25 -0800

damon_sysfs_test_add_targets() creates its monitoring context with
damon_new_ctx(), which leaves ctx->ops zero-initialized.  Since
DAMON_OPS_VADDR is zero, damon_target_has_pid() returns true for the
context, and damon_sysfs_add_targets() therefore calls
damon_set_target_pid() for each target it adds.  That function grabs a
reference to the target's struct pid via find_get_pid().

The test then tears the context down with damon_destroy_ctx(), which
releases such a reference from ctx->ops.cleanup_target().  For the vaddr
operations set that callback is damon_va_cleanup_target(), and it is the
only place where the reference is put.  The test never selects an
operations set, though, so cleanup_target is NULL and both references --
one for each of the two damon_sysfs_add_targets() calls -- are leaked on
every run of the test.  Running the test with CONFIG_DEBUG_KMEMLEAK
enabled reports the leaked struct pid objects as unreferenced.

Fix this by selecting the vaddr operations set for the context before
adding the targets, mirroring what the sysfs interface does.
damon_select_ops() fails if the vaddr operations set is not registered,
in which case the test cannot exercise the pid handling and skips
itself.

Link: https://lore.kernel.org/20261102144627.88843-3-sj@kernel.org
Fixes: b8ee5575f763 ("mm/damon/sysfs-test: add a unit test for damon_sysfs_set_targets()")
Signed-off-by: Wang Xiaolei <xiaoleiwangxiaolei@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Aveline Noir <jm5905938@gmail.com>
Cc: <stable@vger.kernel.org> # 6.7.x
---

 mm/damon/tests/sysfs-kunit.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/damon/tests/sysfs-kunit.h~mm-damon-tests-sysfs-kunit-fix-leaked-pid-reference-in-add_targets-test
+++ a/mm/damon/tests/sysfs-kunit.h
@@ -79,6 +79,15 @@ static void damon_sysfs_test_add_targets
 		kunit_skip(test, "ctx alloc fail");
 	}
 
+	if (damon_select_ops(ctx, DAMON_OPS_VADDR)) {
+		damon_destroy_ctx(ctx);
+		kfree(sysfs_targets->targets_arr);
+		kfree(sysfs_targets);
+		kfree(sysfs_target->regions);
+		kfree(sysfs_target);
+		kunit_skip(test, "vaddr ops not registered");
+	}
+
 	damon_sysfs_add_targets(ctx, sysfs_targets);
 	KUNIT_EXPECT_EQ(test, 1u, nr_damon_targets(ctx));
 
_

Patches currently in -mm which might be from xiaoleiwangxiaolei@gmail.com are

mm-damon-tests-sysfs-kunit-fix-leaked-pid-reference-in-add_targets-test.patch

