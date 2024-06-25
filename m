Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C002143872
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291647; cv=none; b=XCuwzhdZLTqvdLJYINpDQrG49wnhJ0GDbpqPKcF2/k8vlEMdaJyWLc6Nq6VJ6QUfbNhpGzh997fztAkQE3KfLldSRIN4Y4OtJ4RPvprQTYkIE0iMd6VUZ8S2EQ+9oEVsFVMET5IVJa+bQ5og1K9jfKz53zfvSIoAmZRikG2rJZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291647; c=relaxed/simple;
	bh=sgcQFnycdxfTJCSDgIgeYlUiZSm+Al+aJYXvSj2BQt0=;
	h=Date:To:From:Subject:Message-Id; b=HBF4UCKMgF7mvUH7g2eObtwS4/vRik1KzoZCwZJKCL5dMtOFBTHTOahmAc68+CZAuJPCQmJnJ230mPJqD2ZwCC0c4sGxD6hMebnWB87q0w5E7r6+zPZBTRsirWQn0qn+VlGvF2f4mqdwFEl39xNr/+FRtue+mR6zQC0v3GdtR68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zj/Gtkmf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zj/Gtkmf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B5BC4AF0B;
	Tue, 25 Jun 2024 05:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291647;
	bh=sgcQFnycdxfTJCSDgIgeYlUiZSm+Al+aJYXvSj2BQt0=;
	h=Date:To:From:Subject:From;
	b=zj/Gtkmf0Mom2Ml6ytwA7+WW76OQmJ9SUBCwkTZ/W6PECQZFgCKgfXQPz6FZ6t0vd
	 r5guryS36EwzT3y5f6v3KH4owCya5TGyEiZwo53KrRWg57dET/YvX7wMADCyiIpG6X
	 lPg3z4AKNakoFrXGAbpRTSvwLjeXTAldPIxeILOI=
Date: Mon, 24 Jun 2024 22:00:46 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] test_maple_tree-add-the-missing-module_description-macro.patch removed from -mm tree
Message-Id: <20240625050047.16B5BC4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: test_maple_tree: add the missing MODULE_DESCRIPTION() macro
has been removed from the -mm tree.  Its filename was
     test_maple_tree-add-the-missing-module_description-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: test_maple_tree: add the missing MODULE_DESCRIPTION() macro
Date: Fri, 31 May 2024 17:13:16 -0700

make allmodconfig && make W=1 C=1 reports: WARNING: modpost: missing
MODULE_DESCRIPTION() in lib/test_maple_tree.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240531-md-lib-test_maple_tree-v1-1-7b1b485aeec3@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/test_maple_tree.c~test_maple_tree-add-the-missing-module_description-macro
+++ a/lib/test_maple_tree.c
@@ -3946,4 +3946,5 @@ static void __exit maple_tree_harvest(vo
 module_init(maple_tree_seed);
 module_exit(maple_tree_harvest);
 MODULE_AUTHOR("Liam R. Howlett <Liam.Howlett@Oracle.com>");
+MODULE_DESCRIPTION("maple tree API test module");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

backtracetest-add-module_description.patch
lib-ts-add-missing-module_description-macros.patch
kunit-fortify-add-missing-module_description-macros.patch
kunit-add-missing-module_description-macros-for-lib-_testko.patch
lib-asn1_encoder-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-to-lib-_kunitc.patch
uuid-add-missing-module_description-macro.patch
siphash-add-missing-module_description-macro.patch
lib-test_kmod-add-missing-module_description-macro.patch
lib-test_linear_ranges-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-for-lib-test_ko.patch
kfifo-add-missing-module_description-macros.patch
resource-add-missing-module_description.patch
selftests-fpu-add-missing-module_description-macro.patch

