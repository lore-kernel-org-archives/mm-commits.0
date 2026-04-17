Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BED51FBEA6
	for <mm-commits@vger.kernel.org>; Fri, 17 Apr 2026 05:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776405166; cv=none; b=XcsuGSfdRwPg3Ol943yKoIBEMqPQ0h3Iq9d4Fqa4Wlu1ECFFHcoaCyVlJAbELpqaqDMTD3DaY/E3awfULiJtMKr2t1tWCzMNhb5HZHJs1LxgS9lcCMy8WA4aesLUlfC6rCjO9WRnG7cGBnZNWOqY9iusQKBe1YZvwlyal/Li2Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776405166; c=relaxed/simple;
	bh=cuFdPs1DxJfLRu+BL36E2zlBHcm+RPb4ugnKyQZ/YUs=;
	h=Date:To:From:Subject:Message-Id; b=XRWRtGebL663Pptx++g6CHr9nkdDU5Uvyctfo78wd83egvov96J296qoLrr2sC2vETxAF7Czat0eLG350jxESkpXW6g5LfKdGnbMlscCymdTV10X1iFBNdozGjFyi6vmttvQqM8yH7Gsz2REa9Z+wLwp6QAXz1rDdwn/B+IaGFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jxP3183v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jxP3183v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E76AC19425;
	Fri, 17 Apr 2026 05:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776405165;
	bh=cuFdPs1DxJfLRu+BL36E2zlBHcm+RPb4ugnKyQZ/YUs=;
	h=Date:To:From:Subject:From;
	b=jxP3183v8n4cwJ5uZqE5s325JdBt/wI3XhVbJBqNx990ziRPBHJ1IaD4PY0DwV8si
	 6v4XoRQKWdNndqoJxX5n/cMOFclAN5GdFrBl4ame9OhaDreHeAiAp4SoSmeYHQQInz
	 tAA7J0eLhaH1vloCkjuUkmsP72+i2JpgbnQL8A94=
Date: Thu, 16 Apr 2026 22:52:42 -0700
To: mm-commits@vger.kernel.org,yury.khrustalev@arm.com,vbabka@kernel.org,skhan@linuxfoundation.org,rdunlap@infradead.org,mark.rutland@arm.com,ljs@kernel.org,kevin.brodsky@arm.com,david@kernel.org,dave.hansen@linux.intel.com,corbet@lwn.net,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] docs-proc-document-protectionkey-in-smaps-fix.patch removed from -mm tree
Message-Id: <20260417055245.2E76AC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs-proc-document-protectionkey-in-smaps-fix
has been removed from the -mm tree.  Its filename was
     docs-proc-document-protectionkey-in-smaps-fix.patch

This patch was dropped because it was folded into docs-proc-document-protectionkey-in-smaps.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: docs-proc-document-protectionkey-in-smaps-fix
Date: Tue Apr  7 01:55:57 PM PDT 2026

s/system/hardware/, per review discussion

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Yury Khrustalev <yury.khrustalev@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/filesystems/proc.rst~docs-proc-document-protectionkey-in-smaps-fix
+++ a/Documentation/filesystems/proc.rst
@@ -549,7 +549,7 @@ does not take into account swapped out p
 naturally aligned THP pages of any currently enabled size. 1 if true, 0
 otherwise.
 
-If both the kernel and the system support protection keys (pkeys),
+If both the kernel and the hardware support protection keys (pkeys),
 "ProtectionKey" indicates the memory protection key associated with the
 virtual memory area.
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

docs-proc-document-protectionkey-in-smaps.patch
docs-proc-document-protectionkey-in-smaps-fix-fix.patch
maintainers-add-page-cache-reviewer-fix.patch

