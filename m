Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F1118C31
	for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 02:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738116963; cv=none; b=JmflWbWLf/G/0VLaOwPYcm71TCvDogjUr3h5XSjJGILWvbJQ67n9unPQ/5Q85nwS42ysXMRAe7ID9CFg2QtNKMi1UeueLfgsHbtwbp3Nz2kd5zrxPfiQqZ3sTa+5CZtjibe99Eq4yu3j1qjZXOysMPNEzCnOJqEb2ZUCYy1Fiok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738116963; c=relaxed/simple;
	bh=wNJaDRZlTH6+TpoDYPLwY7X5Uohm7RluEd7NEYM8IJs=;
	h=Date:To:From:Subject:Message-Id; b=nBRP3pMNXFNSvizk3rOZO3oei1z3RHdSSmfPIVWNKLI+znKRk+ake4/jRfcUzkJVmfYJRzvG7a9Gxm/2/VfyNDW+A8+7Z68XTtu0uBLWhCMg2InaovBi7mrl9AZplkGjw0X9nwoN1wbcH1McPUKGikLPvnJDVfE4dWjDMVWj7G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xtobPKvc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xtobPKvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A966C4CED3;
	Wed, 29 Jan 2025 02:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738116962;
	bh=wNJaDRZlTH6+TpoDYPLwY7X5Uohm7RluEd7NEYM8IJs=;
	h=Date:To:From:Subject:From;
	b=xtobPKvc4sA9hB86Dj/QDhlEN+kgCCBBNgjPBMdh54+9e/TLdhA4YQFzQdnBwl6cF
	 Xhpo92Id9hdP3TglQmXuCIYNwqJoX/zapisZQrgBHcHtjuZR94MQLMuU71V0tBTEou
	 /lOT9DEXbtddDQPAiEo7dlFe8Pz5VenPipL9hjAM=
Date: Tue, 28 Jan 2025 18:16:01 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,corbet@lwn.net,carlos.bilbao@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-remove-redundant-mappings-of-emails.patch added to mm-nonmm-unstable branch
Message-Id: <20250129021602.9A966C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: .mailmap: remove redundant mappings of emails
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-remove-redundant-mappings-of-emails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-remove-redundant-mappings-of-emails.patch

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
From: Carlos Bilbao <carlos.bilbao@kernel.org>
Subject: .mailmap: remove redundant mappings of emails
Date: Tue, 28 Jan 2025 19:34:30 -0600

Remove two redundant mappings:
changbin.du@intel.com -> changbin.du@intel.com
viresh.kumar@linaro.org -> viresh.kumar@linaro.org

Link: https://lkml.kernel.org/r/20250129013430.1117720-1-carlos.bilbao@kernel.org
Signed-off-by: Carlos Bilbao <carlos.bilbao@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mattew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 --
 1 file changed, 2 deletions(-)

--- a/.mailmap~mailmap-remove-redundant-mappings-of-emails
+++ a/.mailmap
@@ -153,7 +153,6 @@ Carlos Bilbao <carlos.bilbao@kernel.org>
 Carlos Bilbao <carlos.bilbao@kernel.org> <carlos.bilbao@amd.com>
 Carlos Bilbao <carlos.bilbao@kernel.org> <bilbao@vt.edu>
 Changbin Du <changbin.du@intel.com> <changbin.du@gmail.com>
-Changbin Du <changbin.du@intel.com> <changbin.du@intel.com>
 Chao Yu <chao@kernel.org> <chao2.yu@samsung.com>
 Chao Yu <chao@kernel.org> <yuchao0@huawei.com>
 Chester Lin <chester62515@gmail.com> <clin@suse.com>
@@ -748,7 +747,6 @@ Vinod Koul <vkoul@kernel.org> <vkoul@inf
 Viresh Kumar <vireshk@kernel.org> <viresh.kumar2@arm.com>
 Viresh Kumar <vireshk@kernel.org> <viresh.kumar@st.com>
 Viresh Kumar <vireshk@kernel.org> <viresh.linux@gmail.com>
-Viresh Kumar <viresh.kumar@linaro.org> <viresh.kumar@linaro.org>
 Viresh Kumar <viresh.kumar@linaro.org> <viresh.kumar@linaro.com>
 Vishnu Dasa <vishnu.dasa@broadcom.com> <vdasa@vmware.com>
 Vivek Aknurwar <quic_viveka@quicinc.com> <viveka@codeaurora.org>
_

Patches currently in -mm which might be from carlos.bilbao@kernel.org are

mailmap-remove-redundant-mappings-of-emails.patch

