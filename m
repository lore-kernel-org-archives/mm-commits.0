Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA0616FF45
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855620; cv=none; b=jV1S2kO2VSM9eVNEVgICLHdOniv6JrLlZKwkJmzGVK9iEEf6lQOw65hzhhdvOIsCyQmhCEMETRmyto/yupamfISaeN2tDgTZa5EvpDd62Gsw5hOIja/jrOoDyOh9aoD1VYB/lzg7ofHAnug+RJUejMM00D0Q8ABPDZlOMECZ4wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855620; c=relaxed/simple;
	bh=3upkc1Yxz1euHNzfykkQvcNSJgbihs7Q4qkaWK9FTSg=;
	h=Date:To:From:Subject:Message-Id; b=DjprPG5cPyVp9/mY+NkIEwdKqQahPWqOsLAXVl7xs2D1X8CfFkG2+pjDxT37lfGuUVuav6kfAqkCv7jDteaUmskECGB+CBp34DnvDHmBUGHv7ltVhLsD3rXJayYENDfJ/0mQZvv36OEE/RMuL3f9OvBl64IQMmblhNjToMj9mbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EHS2I0yr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EHS2I0yr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3483C4CECF;
	Wed,  6 Nov 2024 01:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855620;
	bh=3upkc1Yxz1euHNzfykkQvcNSJgbihs7Q4qkaWK9FTSg=;
	h=Date:To:From:Subject:From;
	b=EHS2I0yrW7ZViSwFpnizPzy8661vdwYE6KyfS3nFUiZIWsbGc1xjd6DbsSNLYDOwT
	 8Ku7hJPzSAz4LCwbIj6WxAo3GYaEZnOAnvXLqTf25kHFE1+bA4z+lhmI++YvbwAxIw
	 3mbB6adO49WMufMird81DHwDb3MXMW8hGR3YCOcY=
Date: Tue, 05 Nov 2024 17:13:39 -0800
To: mm-commits@vger.kernel.org,davidgow@google.com,richard120310@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] list-test-check-the-size-of-every-lists-for-list_cut_position.patch removed from -mm tree
Message-Id: <20241106011339.F3483C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: list: test: check the size of every lists for list_cut_position*()
has been removed from the -mm tree.  Its filename was
     list-test-check-the-size-of-every-lists-for-list_cut_position.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: I Hsin Cheng <richard120310@gmail.com>
Subject: list: test: check the size of every lists for list_cut_position*()
Date: Tue, 8 Oct 2024 14:52:53 +0800

Check the total number of elements in both resultant lists are correct
within list_cut_position*().  Previously, only the first list's size was
checked.  so additional elements in the second list would not have been
caught.

Link: https://lkml.kernel.org/r/20241008065253.26673-1-richard120310@gmail.com
Signed-off-by: I Hsin Cheng <richard120310@gmail.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list-test.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/lib/list-test.c~list-test-check-the-size-of-every-lists-for-list_cut_position
+++ a/lib/list-test.c
@@ -412,6 +412,8 @@ static void list_test_list_cut_position(
 		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
 		i++;
 	}
+
+	KUNIT_EXPECT_EQ(test, i, 3);
 }
 
 static void list_test_list_cut_before(struct kunit *test)
@@ -440,6 +442,8 @@ static void list_test_list_cut_before(st
 		KUNIT_EXPECT_PTR_EQ(test, cur, &entries[i]);
 		i++;
 	}
+
+	KUNIT_EXPECT_EQ(test, i, 3);
 }
 
 static void list_test_list_splice(struct kunit *test)
_

Patches currently in -mm which might be from richard120310@gmail.com are


