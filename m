Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2701E3019CF
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282038; cv=none; b=C0mUjJyKFmFMXZdPwTowwynr2As33qYcRdP57Y5TQ6VxJ2W/cJ/9MJw6cbDtDlwogNcUW7Fbmwl6JzD9hBarKMTg266NrLWjaYIwgPM61O4yFOXKZbWAFd5wdID4Kie8rs7GaR+CXKMnAdUkogbO49eaPSAvOtDBH2g6VMw/44E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282038; c=relaxed/simple;
	bh=2+zeXgG/MhAy+30WGaUPv3eWY2FN46OjvqrjarRMDG0=;
	h=Date:To:From:Subject:Message-Id; b=k6xnfMwbgZQ1w69VLy4/nbMZgmu+FMk5G14Q824kell2oXl3+/Z6TFKU2zaHDqSCDMO3BYqseGVsh7toVKNWQ6964Btl37pijbR9sPjZtGXJ5XRKbvhyn3PQgtAJkLmGI1KgfbN1GSN1w55rW/wpdEbAYw/4n/Wl3iA4De789yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nkjbP6k2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nkjbP6k2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938FCC4CEF8;
	Thu, 27 Nov 2025 22:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282037;
	bh=2+zeXgG/MhAy+30WGaUPv3eWY2FN46OjvqrjarRMDG0=;
	h=Date:To:From:Subject:From;
	b=nkjbP6k2xaEYZ9OkfarOFx3sF/5P3n6nQ5jcagWti0EtF4h/xdEGxWuzdVdI08CyL
	 3qI3W1E2zLVlKys1fYoTFCYy8rLe9FsiqXwNfyn4YIAvWt401xlM7S3rkRRckveljQ
	 ZfeeooRqK7i1M1itLpoNV25iOeiDD1RtG9SneGuI=
Date: Thu, 27 Nov 2025 14:20:36 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] liveupdate-luo_session-add-sessions-support-fix.patch removed from -mm tree
Message-Id: <20251127222037.938FCC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate: luo_session: fix use after free in luo_session_deserialize()
has been removed from the -mm tree.  Its filename was
     liveupdate-luo_session-add-sessions-support-fix.patch

This patch was dropped because it was folded into liveupdate-luo_session-add-sessions-support.patch

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: liveupdate: luo_session: fix use after free in luo_session_deserialize()
Date: Wed, 26 Nov 2025 17:51:40 +0300

The debug output frees "session" but it was freed on the previous line. 
Move the free after the printk().

Link: https://lkml.kernel.org/r/c5dd637d7eed3a3be48c5e9fedb881596a3b1f5a.1764163896.git.dan.carpenter@linaro.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_session.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/liveupdate/luo_session.c~liveupdate-luo_session-add-sessions-support-fix
+++ a/kernel/liveupdate/luo_session.c
@@ -387,9 +387,9 @@ int luo_session_deserialize(void)
 
 		err = luo_session_insert(sh, session);
 		if (err) {
-			luo_session_free(session);
 			pr_warn("Failed to insert session [%s] %pe\n",
 				session->name, ERR_PTR(err));
+			luo_session_free(session);
 			return err;
 		}
 	}
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

liveupdate-luo_session-add-sessions-support.patch

