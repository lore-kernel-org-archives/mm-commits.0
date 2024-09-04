Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790147406F
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423527; cv=none; b=spze6hEHiHpPMW8+yZ3mmG4RMZFUo2ZL9BL7MqcRciL1QXXIoP93VpwRBtU2/y8NU2zkuXFClKPAJGI+kLBPFAHfecPP9GYVk7wtONVQIff8q0obf1GaSo4qWlBFlUngwa+vmXYrqwcPX9YtxlipBknHy9dqz4Mdznm0iuT7lDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423527; c=relaxed/simple;
	bh=jgLFo9lIDGbCgFOiAif5JDgIHGo+M7I4cULSomQg260=;
	h=Date:To:From:Subject:Message-Id; b=j1LL8+nwysgh/kXBUf4nXxkX9tOm8k2wYV8bVAwFhVYHsAByR/bbLt/wwnTk1TZESZod1EPRbDxCVrZ6F/vY2Gpx4lbQ+Ar03JGRh3tyn+kEJ4R0IuUdy/sy5ZTUqwzbCtrNHhM/GjQvRt+fca1nMAnS2O9SleipbMw33XRhiTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1dc2cNig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1dc2cNig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5B3C4CEC2;
	Wed,  4 Sep 2024 04:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423527;
	bh=jgLFo9lIDGbCgFOiAif5JDgIHGo+M7I4cULSomQg260=;
	h=Date:To:From:Subject:From;
	b=1dc2cNigflxEqbP157TjGlGmRL7tfcmhbmz1GqLDzilFfS7ZZgBdPQy3EnByn0k5m
	 eXWpaU+hJGeQZqtC++4jhrPv5rHcaEvJb8Stpqq9X4i3Gv6S8Bw+hzzrJf9ipN9MJf
	 E9eRtQNM4d7C3ugDEVR/CIPTvxcuBZz54O9YZAMg=
Date: Tue, 03 Sep 2024 21:18:46 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-pagereadahead.patch removed from -mm tree
Message-Id: <20240904041847.4D5B3C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove PageReadahead
has been removed from the -mm tree.  Its filename was
     mm-remove-pagereadahead.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove PageReadahead
Date: Wed, 21 Aug 2024 20:34:36 +0100

This flag is now only used on folios, so we can remove all the page
accessors.

Link: https://lkml.kernel.org/r/20240821193445.2294269-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-pagereadahead
+++ a/include/linux/page-flags.h
@@ -553,8 +553,8 @@ PAGEFLAG(MappedToDisk, mappedtodisk, PF_
 /* PG_readahead is only used for reads; PG_reclaim is only for writes */
 PAGEFLAG(Reclaim, reclaim, PF_NO_TAIL)
 	TESTCLEARFLAG(Reclaim, reclaim, PF_NO_TAIL)
-PAGEFLAG(Readahead, readahead, PF_NO_COMPOUND)
-	TESTCLEARFLAG(Readahead, readahead, PF_NO_COMPOUND)
+FOLIO_FLAG(readahead, FOLIO_HEAD_PAGE)
+	FOLIO_TEST_CLEAR_FLAG(readahead, FOLIO_HEAD_PAGE)
 
 #ifdef CONFIG_HIGHMEM
 /*
_

Patches currently in -mm which might be from willy@infradead.org are

swap-convert-swapon-to-use-a-folio.patch

