Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB7E85C4A;
	Tue, 26 Aug 2025 01:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756170340; cv=none; b=oSA/J04nFMtG9bknw7Q/bvY49oUHfhJsf6jOhiaX3zFdwHlnsCDSEVm5QkPoq7w/jg6FzDsEG3GOMl06IO2NLXvxiQj4fYaKz6/PBoE3rbHVqEVixdSEJesDUODnoqCBfVun5qckZ1u2OkaJeIi9wrayhOOkeM/6hqKkHrBp0pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756170340; c=relaxed/simple;
	bh=JngFn+jzgyIn12/qv12mpOgI7nfL8G9DKZcKVXiPB9I=;
	h=Date:To:From:Subject:Message-Id; b=P18r7nFKpqCN/3neQMiUNSxm+Uabg8bszbKMP/mcxDbdNOkp4bTcx7hmnNBz0pQhmBXZwWViuixXq1mxzyIyMYawRmA3a44IG6qgoRL6QPOCBckX41qUHWbRjQLZbX4SaFuvTb5D6kd6PR/XOS+5FU0WsB5MVWTEJluVlpNJSV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FZjQujsZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FZjQujsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90CEC4CEED;
	Tue, 26 Aug 2025 01:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756170339;
	bh=JngFn+jzgyIn12/qv12mpOgI7nfL8G9DKZcKVXiPB9I=;
	h=Date:To:From:Subject:From;
	b=FZjQujsZhEPNHPJQIaigp1jBB11uAyVv5YFpFl7y5KR8yc/wOz7vea6exDk2XSeJo
	 gvxnCV7C2sP6LhgorcvhG/vjhJ9yi2HmuTaOf9sEDHKWFsq9eJ14foMyer5aNnE2M8
	 Jw0PSzo+DJp9joQLk48/ThwhYEpeSqyQXAS003JE=
Date: Mon, 25 Aug 2025 18:05:38 -0700
To: mm-commits@vger.kernel.org,vkuznets@redhat.com,stable@vger.kernel.org,ryncsn@gmail.com,okozina@redhat.com,kernelfans@gmail.com,gmazyland@gmail.com,dyoung@redhat.com,dave.hansen@intel.com,coxu@redhat.com,bhe@redhat.com,berrange@redhat.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-arm64-initialize-the-random-field-of-kbuf-to-zero-in-the-image-loader.patch added to mm-hotfixes-unstable branch
Message-Id: <20250826010539.A90CEC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec/arm64: initialize the random field of kbuf to zero in the image loader
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kexec-arm64-initialize-the-random-field-of-kbuf-to-zero-in-the-image-loader.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-arm64-initialize-the-random-field-of-kbuf-to-zero-in-the-image-loader.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Breno Leitao <leitao@debian.org>
Subject: kexec/arm64: initialize the random field of kbuf to zero in the image loader
Date: Thu Aug 21 04:11:21 2025 -0700

Add an explicit initialization for the random member of the kbuf structure
within the image_load function in arch/arm64/kernel/kexec_image.c. 
Setting kbuf.random to zero ensures a deterministic and clean starting
state for the buffer used during kernel image loading, avoiding this UBSAN
issue later, when kbuf.random is read.

  [   32.362488] UBSAN: invalid-load in ./include/linux/kexec.h:210:10
  [   32.362649] load of value 252 is not a valid value for type '_Bool'

Link: https://lkml.kernel.org/r/oninomspajhxp4omtdapxnckxydbk2nzmrix7rggmpukpnzadw@c67o7njgdgm3
Fixes: bf454ec31add ("kexec_file: allow to place kexec_buf randomly
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Liu Pingfan <kernelfans@gmail.com>
Cc: Milan Broz <gmazyland@gmail.com>
Cc: Ondrej Kozina <okozina@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/kexec_image.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kernel/kexec_image.c~kexec-arm64-initialize-the-random-field-of-kbuf-to-zero-in-the-image-loader
+++ a/arch/arm64/kernel/kexec_image.c
@@ -76,6 +76,7 @@ static void *image_load(struct kimage *i
 	kbuf.buf_min = 0;
 	kbuf.buf_max = ULONG_MAX;
 	kbuf.top_down = false;
+	kbuf.random = 0;
 
 	kbuf.buffer = kernel;
 	kbuf.bufsz = kernel_len;
_

Patches currently in -mm which might be from leitao@debian.org are

kexec-arm64-initialize-the-random-field-of-kbuf-to-zero-in-the-image-loader.patch

