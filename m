Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293136;
	b=d6pzbPidmZrKvNtbzl6zw5Wfz78M7R93qMMX5oDzuusLPF0ks0exmJKx0la3nUZwk306
	 8eNjWe6PmPzmRJtqJuznxRHxRaFfli45cRNz06w8xrhTFzhGRsAgmv6FxGS/D670bWBk2
	 o3VMaEAOO/EjRsK8jqfZg4VmVWtGZCyRdAoyXrXw9ExwiJU/t10Df/oNo2o6Sgdmy3FBY
	 pE4fw5+++eextwq0c8I7melpnnzxM5c+7S/C45ZMxTgTJvnYDgrfia8wSh8wW1Puhi9ls
	 U+zyVigIDP2DHknaXN6jw5BCQW1Z13x/AuB+h/VhJzLBJLum0cdljARlfDrnQa7TefQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293136;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=go8SxZcqB/2A1594xHyqs4oEq/LjPrko7SvXzyhAcsI=;
	b=N1B2zNbFesMfQch7962O65jELf/pcwn94o/QLvK9ODxdw5nswUM34rd3FEQh1RpgPsXb
	 CwvGaOTkXcNEmXVN4vqzOSErCX0NAa1+OrQrXzPA+ijVCguUw8asJyz0zqJ6i4kGrtmfp
	 /Ka1tQbJZHOMMAKGkmYQkMEWWS+A5ZhQSnflP33xP9tH5fYpQy1yPF3exeSx8oTKDBj0M
	 iHCnChtcyd3PY9pzivGikavuMduXCf8OTUb7UuaL3xt4uoUc2JNrdC3ePHF3e4jJ6dgj2
	 5BcMb4xfgRKejm5shwZSdW/R+wpHRw1qNagtP6tVu5TnA7f8AhzR+7tfVe/IU5yhA3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=k9wYJy4a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2745F606CB3E;
	Tue, 10 Nov 2026 06:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=k9wYJy4a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A821F008A2;
	Tue, 10 Nov 2026 06:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293135;
	bh=go8SxZcqB/2A1594xHyqs4oEq/LjPrko7SvXzyhAcsI=;
	h=Date:To:From:Subject;
	b=k9wYJy4ap21RStHUYMHkZmXuvSUu94Xm8b5/AMjQRDS52Jk+B905A66L2rLAVZKzH
	 Ma+5+TyruZaEK2v0Vb74PTNu6mCbjopBKLpmusMWc9a8LNCyaWprC27SgwII9uBzCd
	 C+D7Ha5pEExV8HZQaARDFGKDlTg8s2AvbHQiZVoM=
Date: Mon, 09 Nov 2026 22:45:35 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	stable@vger.kernel.org,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,
	liam@infradead.org,jm5905938@gmail.com,davidgow@davidgow.net,
	brendan.higgins@linux.dev,xiaoleiwangxiaolei@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-tests-sysfs-kunit-fix-leaked-pid-reference-in-add_targets-test.patch removed from -mm tree
Message-Id: <20261110064535.D1A821F008A2@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/damon/tests/sysfs-kunit: fix leaked pid reference in add_targets test
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-sysfs-kunit-fix-leaked-pid-reference-in-add_targets-test.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


