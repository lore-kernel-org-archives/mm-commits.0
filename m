Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48417DA6C
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 18:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728411491; cv=none; b=uqjSEubVQ95REX2YqGYvXJJ3lY2md9CQl7P1VMa9VvFhUb2Y1rSpFzU7T57Qtiv57NyELLbhIlhNYRfJWQTUuuOy6NE45+qIg6KcJyumf1d6j5xxpSCA6tNmbmP8W2VzjAW8j3rmRefPsdGanf9Gu2EsQLBOu1kzkoTsUo2tISY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728411491; c=relaxed/simple;
	bh=D6Xf92sRbL45mrvicHQcYqpDr8FnlpNmKr9/cr13X60=;
	h=Date:To:From:Subject:Message-Id; b=gR+ChOtEgg8nVkz5k8Au9DLVEpUOmndebuX7KBTZWLqtpa9TKhtyOhOO2nC/pbaWPG3u1H3OjruTkMXZDCrq4HkOMHCbLcDtQb8lzTepWMCqWG59iNwptAJ3EecLDzLKuy+wrgUpMaK8tOnBiB8mox/gAdfPjWkTo6gsRTSlyNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rRMU77XR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rRMU77XR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E48EC4CEC7;
	Tue,  8 Oct 2024 18:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728411490;
	bh=D6Xf92sRbL45mrvicHQcYqpDr8FnlpNmKr9/cr13X60=;
	h=Date:To:From:Subject:From;
	b=rRMU77XRBkWgOP8WRALbaGi/StLq4fBP6qRkixwbuQz5xKyDh/70TaqeDk9BtI/fG
	 NpMb3PgTrIPBZEJ/twYCUX2vLo5nNdgQCDfAduc0GngIV+mlq9mCKNVWCokFwdx1Ou
	 AwNJWOu2tlKbLd1msA6wNBnS831N504EIarJj49A=
Date: Tue, 08 Oct 2024 11:18:09 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,richard120310@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + list-test-check-the-size-of-every-lists-for-list_cut_position.patch added to mm-nonmm-unstable branch
Message-Id: <20241008181810.8E48EC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: list: test: check the size of every lists for list_cut_position*()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     list-test-check-the-size-of-every-lists-for-list_cut_position.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/list-test-check-the-size-of-every-lists-for-list_cut_position.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

list-test-check-the-size-of-every-lists-for-list_cut_position.patch

