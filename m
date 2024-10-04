Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE33F21A1C
	for <mm-commits@vger.kernel.org>; Fri,  4 Oct 2024 02:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728008779; cv=none; b=E4U7fpbkGnpdXlqYd0BvEbEa2TkCqIN2JVXp034tbxNZmNUdJVkVkvML9QOkDQuEyCzeVGwaCVsUlrLu12rFb0a8MqkHMk0qoaeKQoSbZEciWZSiU26qSzjfOpxppYUXKMOPulaEzJa6mQ6hTgx+S6bEv36eY31S/tIx+Xrs+io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728008779; c=relaxed/simple;
	bh=273K+Xh68vv1Gsr5Ynv9Uw8w26kmLYpHsSEuYwjcCbM=;
	h=Date:To:From:Subject:Message-Id; b=BdCgEmEGdK/M8dNDfnvpxMT/2SE+sQlymH+JZ2BMhn/ZO/Fbwzpq7hfpJakPjP8jAjBZnphiEgHn3rC7P5XmDQgXPwW+bmphMZJR5m/75tFS517F1BZtuC/Jr/o63Lb+cFWkmUhNc5cqN6YXe+6p2M2RKJvjEvXApEtZQ/RNAC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bm7IR8u6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bm7IR8u6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A53C4CECC;
	Fri,  4 Oct 2024 02:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728008778;
	bh=273K+Xh68vv1Gsr5Ynv9Uw8w26kmLYpHsSEuYwjcCbM=;
	h=Date:To:From:Subject:From;
	b=Bm7IR8u6v7eUHR7MRqIhsaWqp+3b0lSqa9UPkzCxwqagDdSD7T5x0UPmCf2EHtI/n
	 zKJMO7HhRvrowzSc1bQnjS+waLdlR0y0kwWfk0nYRcN7i8K98vRJ84SW1LhZ1J97Be
	 vCrPQrTJjJMyY/aEWKdx68nmPU/cu+9/PoJFBSGo=
Date: Thu, 03 Oct 2024 19:26:18 -0700
To: mm-commits@vger.kernel.org,kees@ijzerbout.nl,david@redhat.com,dan.j.williams@intel.com,bhelgaas@google.com,ying.huang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] resource-kunit-fix-user-after-free-in-resource_test_region_intersects.patch removed from -mm tree
Message-Id: <20241004022618.C1A53C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: resource, kunit: fix user-after-free in resource_test_region_intersects()
has been removed from the -mm tree.  Its filename was
     resource-kunit-fix-user-after-free-in-resource_test_region_intersects.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: resource, kunit: fix user-after-free in resource_test_region_intersects()
Date: Mon, 30 Sep 2024 15:06:11 +0800

In resource_test_insert_resource(), the pointer is used in error message
after kfree().  This is user-after-free.  To fix this, we need to call
kunit_add_action_or_reset() to schedule memory freeing after usage.  But
kunit_add_action_or_reset() itself may fail and free the memory.  So, its
return value should be checked and abort the test for failure.  Then, we
found that other usage of kunit_add_action_or_reset() in
resource_test_region_intersects() needs to be fixed too.  We fix all these
user-after-free bugs in this patch.

Link: https://lkml.kernel.org/r/20240930070611.353338-1-ying.huang@intel.com
Fixes: 99185c10d5d9 ("resource, kunit: add test case for region_intersects()")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reported-by: Kees Bakker <kees@ijzerbout.nl>
Closes: https://lore.kernel.org/lkml/87ldzaotcg.fsf@yhuang6-desk2.ccr.corp.intel.com/
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource_kunit.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/kernel/resource_kunit.c~resource-kunit-fix-user-after-free-in-resource_test_region_intersects
+++ a/kernel/resource_kunit.c
@@ -169,6 +169,8 @@ static void resource_test_intersection(s
 #define RES_TEST_RAM3_SIZE	SZ_1M
 #define RES_TEST_TOTAL_SIZE	((RES_TEST_WIN1_OFFSET + RES_TEST_WIN1_SIZE))
 
+KUNIT_DEFINE_ACTION_WRAPPER(kfree_wrapper, kfree, const void *);
+
 static void remove_free_resource(void *ctx)
 {
 	struct resource *res = (struct resource *)ctx;
@@ -177,6 +179,14 @@ static void remove_free_resource(void *c
 	kfree(res);
 }
 
+static void resource_test_add_action_or_abort(
+	struct kunit *test, void (*action)(void *), void *ctx)
+{
+	KUNIT_ASSERT_EQ_MSG(test, 0,
+			    kunit_add_action_or_reset(test, action, ctx),
+			    "Fail to add action");
+}
+
 static void resource_test_request_region(struct kunit *test, struct resource *parent,
 					 resource_size_t start, resource_size_t size,
 					 const char *name, unsigned long flags)
@@ -185,7 +195,7 @@ static void resource_test_request_region
 
 	res = __request_region(parent, start, size, name, flags);
 	KUNIT_ASSERT_NOT_NULL(test, res);
-	kunit_add_action_or_reset(test, remove_free_resource, res);
+	resource_test_add_action_or_abort(test, remove_free_resource, res);
 }
 
 static void resource_test_insert_resource(struct kunit *test, struct resource *parent,
@@ -202,11 +212,11 @@ static void resource_test_insert_resourc
 	res->end = start + size - 1;
 	res->flags = flags;
 	if (insert_resource(parent, res)) {
-		kfree(res);
+		resource_test_add_action_or_abort(test, kfree_wrapper, res);
 		KUNIT_FAIL_AND_ABORT(test, "Fail to insert resource %pR\n", res);
 	}
 
-	kunit_add_action_or_reset(test, remove_free_resource, res);
+	resource_test_add_action_or_abort(test, remove_free_resource, res);
 }
 
 static void resource_test_region_intersects(struct kunit *test)
@@ -220,7 +230,7 @@ static void resource_test_region_interse
 				       "test resources");
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, parent);
 	start = parent->start;
-	kunit_add_action_or_reset(test, remove_free_resource, parent);
+	resource_test_add_action_or_abort(test, remove_free_resource, parent);
 
 	resource_test_request_region(test, parent, start + RES_TEST_RAM0_OFFSET,
 				     RES_TEST_RAM0_SIZE, "Test System RAM 0", flags);
_

Patches currently in -mm which might be from ying.huang@intel.com are


