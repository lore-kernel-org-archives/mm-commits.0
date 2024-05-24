Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA613EA64
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 18:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716576736; cv=none; b=fMDJCXMH5GgO4dNZrOcnRAQYyCooOMZwLIhH5dZO8IQ4XZvDPB2QUHNTIFtlP2bhfRjctjvLXgHM3BPGk+XvNF2FPiDA8hkEMbs3x2eI1neACy4Vxt0W+aEdLZYQTHFHpeYBQHnG+9gkEMYZiyyBlyq9urDu/XAB3Q+MIAsY6oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716576736; c=relaxed/simple;
	bh=EnnGUJiS5xeSjD2iZTAd5G6xzdj0f0kbZ6A0SodQsZY=;
	h=Date:To:From:Subject:Message-Id; b=nJ5YSbzrcJRaJmQGFbhGDRG9DK1xOYhj1SnQkDK5mRl3AOIlIB2JkOVE7/9NS4t9Dy2Lg5C1DIc0H+wJbIAOG3EkNMEucz6Kq+kmX++R3Le0OoME8pbDSdfyvyum5LLYIAtgQm17ah/Khz8uqFmjVGbk1t/T+3eYrCo0xavowmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KCwEXsH5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KCwEXsH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9ECC2BBFC;
	Fri, 24 May 2024 18:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716576736;
	bh=EnnGUJiS5xeSjD2iZTAd5G6xzdj0f0kbZ6A0SodQsZY=;
	h=Date:To:From:Subject:From;
	b=KCwEXsH5jwsX4QUtGpC40oRd+FGGtczVR+4SZ2bzbIhaXsBTB68I27JQp3h8vexEJ
	 RlY36xm3EX4lsjUf23yPsnZsNzevQw4jyZ67p4NWS+KFsga6iY9qAsOZggufDV3Zdm
	 qDnZaqc5upYLOIaOW49Ekd8G0BrsZIIXSSisY5Og=
Date: Fri, 24 May 2024 11:52:15 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,keescook@chromium.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-add-version-into-proc-allocinfo-output-fix.patch removed from -mm tree
Message-Id: <20240524185216.4B9ECC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib-add-version-into-proc-allocinfo-output-fix
has been removed from the -mm tree.  Its filename was
     lib-add-version-into-proc-allocinfo-output-fix.patch

This patch was dropped because it was folded into lib-add-version-into-proc-allocinfo-output.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-add-version-into-proc-allocinfo-output-fix
Date: Tue May 14 01:19:12 PM PDT 2024

remove stray newline from struct allocinfo_private

Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/alloc_tag.c~lib-add-version-into-proc-allocinfo-output-fix
+++ a/lib/alloc_tag.c
@@ -19,7 +19,6 @@ DEFINE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC
 struct allocinfo_private {
 	struct codetag_iterator iter;
 	bool print_header;
-
 };
 
 static void *allocinfo_start(struct seq_file *m, loff_t *pos)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-add-version-into-proc-allocinfo-output.patch

