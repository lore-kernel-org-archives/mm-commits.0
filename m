Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC5F1E884
	for <mm-commits@vger.kernel.org>; Tue, 12 Nov 2024 01:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731374572; cv=none; b=AjWWxNDbp3/9RpBvK/gpDZC76RD/F86KiboriDHSYJ6wCwDhixUQN63TVFFlDbJAbuYK9GoZRa247UV2S3HLJFI/8ZoBO+Ob3hVoIMmlhHB4xLNCjZD1C0Xmr3bbr/O0zk060uFnQWTUYB4+NevPAotMtq3BK1hD26xB5ksE8oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731374572; c=relaxed/simple;
	bh=zHNbWDcoRcDIf/vCuE8/X36iQ0sy1mwBEZQwAcw2FnI=;
	h=Date:To:From:Subject:Message-Id; b=QgZzNWiURNVK+KRbQG/36Vp1eUQXaR2wFIgvjbpf/ZS6SilC7qLfIAhoLEalJkLsIaBOvVw/2oaWC88O4uC2bZ4KWQeDmD7nFmxsW0LvnreDpqSHvvGL75GjcXnmdNh8pYloo40RCDdmaWXTLuYCRsUCZwH2P7ctscR+LH9LyFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f0wpx3PV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f0wpx3PV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71406C4CECF;
	Tue, 12 Nov 2024 01:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731374572;
	bh=zHNbWDcoRcDIf/vCuE8/X36iQ0sy1mwBEZQwAcw2FnI=;
	h=Date:To:From:Subject:From;
	b=f0wpx3PVQEaujeU1y17s26xsyte1YhUzu+eew5uSfx7C/acBf1dN18LWTxxQTowAx
	 RE8518iBF8eFp9zB5fskAhqpNl7qylm1b56oAG9Z4EkfEBOM2YcZ+74MmCEY+hLiU+
	 pWVwHr2pXkSw88VoAFEKEMn5Yr1SVrl5FW/vPEFc=
Date: Mon, 11 Nov 2024 17:22:51 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,ryabinin.a.a@gmail.com,dvyukov@google.com,andreyknvl@gmail.com,niharchaithanya@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-add-kunit-tests-for-kmalloc_track_caller-kmalloc_node_track_caller.patch removed from -mm tree
Message-Id: <20241112012252.71406C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: add kunit tests for kmalloc_track_caller, kmalloc_node_track_caller
has been removed from the -mm tree.  Its filename was
     kasan-add-kunit-tests-for-kmalloc_track_caller-kmalloc_node_track_caller.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nihar Chaithanya <niharchaithanya@gmail.com>
Subject: kasan: add kunit tests for kmalloc_track_caller, kmalloc_node_track_caller
Date: Tue, 15 Oct 2024 00:31:30 +0530

The Kunit tests for kmalloc_track_caller and kmalloc_node_track_caller
were missing in kasan_test_c.c, which check that these functions poison
the memory properly.

Add a Kunit test:
-> kmalloc_tracker_caller_oob_right(): This includes out-of-bounds
   access test for kmalloc_track_caller and kmalloc_node_track_caller.

Link: https://lkml.kernel.org/r/20241014190128.442059-1-niharchaithanya@gmail.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216509
Signed-off-by: Nihar Chaithanya <niharchaithanya@gmail.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/mm/kasan/kasan_test_c.c~kasan-add-kunit-tests-for-kmalloc_track_caller-kmalloc_node_track_caller
+++ a/mm/kasan/kasan_test_c.c
@@ -215,6 +215,36 @@ static void kmalloc_node_oob_right(struc
 	kfree(ptr);
 }
 
+static void kmalloc_track_caller_oob_right(struct kunit *test)
+{
+	char *ptr;
+	size_t size = 128 - KASAN_GRANULE_SIZE;
+
+	/*
+	 * Check that KASAN detects out-of-bounds access for object allocated via
+	 * kmalloc_track_caller().
+	 */
+	ptr = kmalloc_track_caller(size, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+
+	OPTIMIZER_HIDE_VAR(ptr);
+	KUNIT_EXPECT_KASAN_FAIL(test, ptr[size] = 'y');
+
+	kfree(ptr);
+
+	/*
+	 * Check that KASAN detects out-of-bounds access for object allocated via
+	 * kmalloc_node_track_caller().
+	 */
+	ptr = kmalloc_node_track_caller(size, GFP_KERNEL, 0);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+
+	OPTIMIZER_HIDE_VAR(ptr);
+	KUNIT_EXPECT_KASAN_FAIL(test, ptr[size] = 'y');
+
+	kfree(ptr);
+}
+
 /*
  * Check that KASAN detects an out-of-bounds access for a big object allocated
  * via kmalloc(). But not as big as to trigger the page_alloc fallback.
@@ -2015,6 +2045,7 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kmalloc_oob_right),
 	KUNIT_CASE(kmalloc_oob_left),
 	KUNIT_CASE(kmalloc_node_oob_right),
+	KUNIT_CASE(kmalloc_track_caller_oob_right),
 	KUNIT_CASE(kmalloc_big_oob_right),
 	KUNIT_CASE(kmalloc_large_oob_right),
 	KUNIT_CASE(kmalloc_large_uaf),
_

Patches currently in -mm which might be from niharchaithanya@gmail.com are


