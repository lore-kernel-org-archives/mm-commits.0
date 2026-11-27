Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795743004;
	b=oWYTfy6jWvqWBvlYEILtsSHSpIuL+S/IAmefTw7iDrcMZ08udiHqn1wSX+Uiyzx76A6E
	 SjIt7BqUb9xLoeTbYX5uYK0S2kC7A7jkumZo5D98XJcLB3QSa1tyWmQMN5guc+EJxzZa4
	 pCHKgNZ6AkTq04IVjFiWH+Jk9KDprkCNkjffrFCwXetXC/Q6748Y2olMYgHDgsxO7CB8N
	 ZElNnDEI80eqLMPZMIZOdjAveD0g1fEodDqzu0Xa48vP/+hNFLP38x5wZNsn0jHa1Vbvo
	 z3FSH8d9jK3/vUc0dRliIrExIq4FTOnXY11EHZ5GOoDx4Rb0jIveSJgRoehVkDL7sVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795743004;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=fKIR8qP3nd73b/ddp4djUyLrSLCOodjBfW7AVb+A7yQ=;
	b=40jGJO3Eu7UO8MGmK+RjdCfQiowUFT1uWCS97Hv0cV0pKOl/K4IZO5q5/wKOJa6uvvZD
	 qCOiP1SGPZlveCpdRNdBIQEucnnkeSzGM5No8jaiDynYgt3Rt1VfwmQrOj2Eoi01hz+v6
	 Q/xg9gWkjPp6R4RWzgTfAzU52L3sHkcui5WH9tiFnuAVvGBijnQcT3+JTSXQtD9e7lWMZ
	 g8gmuYccuom4SHLUkRYmpfIrWye/ZaESwHJnbDFoqVOww5YJPgLMH5kqzEXw5FRkj4UsM
	 NnOUd4PzSHw+18J1rUxFydVKYLtZtzTt34WB4KrereVXhZvcWe6ptdAHBCqNQ3SfzEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TRGb6MEI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EDF606A31E
	for <mm-commits@vger.kernel.org>; Fri, 27 Nov 2026 01:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TRGb6MEI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53D01F00893;
	Fri, 27 Nov 2026 01:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795743003;
	bh=fKIR8qP3nd73b/ddp4djUyLrSLCOodjBfW7AVb+A7yQ=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=TRGb6MEIi7omRfkwsmGFdTAnUn7umntdwQlxmeZubOoB0GU12g2ft6z0YfXXB563a
	 ltnRB55gdf1+r8+l06bekX/pWNNUr1QGHPYhFElAn6PU1n+0l2KRTaFy2UnXv1m3nd
	 862sXOZb7RhJXE2cvc3TETS+bse7ogH1p9RgZIvo=
Date: Thu, 26 Nov 2026 17:30:03 -0800
To: mm-commits@vger.kernel.org,zhen.ni@easystack.cn,vbabka@kernel.org,
	skhan@linuxfoundation.org,rppt@kernel.org,rdunlap@infradead.org,
	mhocko@suse.com,liam@infradead.org,kernel-dev@igalia.com,david@kernel.org,
	corbet@lwn.net,mfo@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261126-page_owner_filter_shell-v1-1-cbbcff2fcb08@igalia.com>
References: <20261126-page_owner_filter_shell-v1-1-cbbcff2fcb08@igalia.com>
Subject: + mm-page_owner-document-shell-usage-of-page_owner-filters.patch added to mm-new branch
Message-Id: <20261127013003.C53D01F00893@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/page_owner: document shell usage of page_owner filters
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-document-shell-usage-of-page_owner-filters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-document-shell-usage-of-page_owner-filters.patch

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
From: Mauricio Faria de Oliveira <mfo@igalia.com>
Subject: mm/page_owner: document shell usage of page_owner filters
Date: Thu, 26 Nov 2026 13:40:02 -0300

Document how to use page_owner filters directly from the shell, without
relying on the page_owner_filter tool, with an example.

Link: https://patch.msgid.link/20261126-page_owner_filter_shell-v1-1-cbbcff2fcb08@igalia.com
Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Zhen Ni <zhen.ni@easystack.cn>
Cc: <kernel-dev@igalia.com>

 Documentation/mm/page_owner.rst |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/Documentation/mm/page_owner.rst~mm-page_owner-document-shell-usage-of-page_owner-filters
+++ a/Documentation/mm/page_owner.rst
@@ -343,3 +343,21 @@ terminals you can run different filters
 
 	# Terminal 2: Filter node 1 (runs concurrently)
 	./page_owner_filter -n 1 > node1_output.txt
+
+The shell can also be used instead of the page_owner_filter tool, as long as the
+same file descriptor is used to write filter commands then read filtered output.
+For example, using file descriptor 3::
+
+	# Open file in read-write mode
+	exec 3<>/sys/kernel/debug/page_owner
+
+	# Write filter command(s)
+	echo 'mode=handle' >&3
+	# (and/or)
+	echo 'nid=0' >&3
+
+	# Read filtered output
+	cat <&3 >output.txt
+
+	# Close file
+	exec 3>&-
_

Patches currently in -mm which might be from mfo@igalia.com are

mm-page_owner-document-shell-usage-of-page_owner-filters.patch
scripts-bloat-o-meter-describe-output-fields-in-help-text.patch

