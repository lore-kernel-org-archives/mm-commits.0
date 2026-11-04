Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793778699;
	b=OUMX68sIwTURuYhftXrml57vBYv9G8JD1S674s4S8gegVnilbfCof1JNXmB3D9gcO2bx
	 R4iLVwVrsO25+z4Daq/gnM12bGksEay3MWaOK9rJnqKXFj7Qlx41RzjBo/IioLnNfKln9
	 iOuCKFMTYEXVnvgw0I+No2kbkABnJTnk9FukfaODNkLDGPQm4UAXNFBtIzLRc0EThDOSF
	 XgCbdwmrvBlS6WUEdgih3ugJRlnWIxhOcKdcjW7cVDfZaoqp+0WN/nifLzPA4EgpPXPnO
	 P9EkaSgK+rMQXHlIG352dJ/+cz8aCrJkvr673oDJdzzBoDrSc1AP9y27Dp1FyQbr83g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793778699;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=3MpRekUw5MjXBsn2XyZ+L8a67L76IszNdjHS5fBaJJs=;
	b=yXUSaCuqDP4zVv0tntYEmRYf/eJD34ZCc8vE/33OhjeRiymvavm0l6gCdfX8mPZWaH2/
	 8eiexB4giZuWQ3l2G9WByRiYVgsAHFBwoYyjzQdd4kPEK1mdg9NqSNPu/sATscuTrb0Sj
	 sT1htwRCv5WMDS8xdZPrKCNh1i+2rK1Bi1LdzLM4WBSz4mldm3lOGM6SGY61hVskkxGRw
	 nCHq3iKSzvFIMUHUP5uJkfrTi4+CT6f+XAeJJJjFfsfBatVf5nmv3r6Ti0TM9zAjo/v/G
	 8QG60hjY7YaEJTlXZ4ITQYyVlLwXoj6mZgORJLFdVR8BAtld2VvEN4+k+7WhHXXjrjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=E0XVde5D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9D0606A329
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 07:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=E0XVde5D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A721F000C1;
	Wed,  4 Nov 2026 07:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793778698;
	bh=3MpRekUw5MjXBsn2XyZ+L8a67L76IszNdjHS5fBaJJs=;
	h=Date:To:From:Subject;
	b=E0XVde5DsZQyai6quPI4invhjFhf1wpu52HXToQDXeAT4Bikxm1oSqvJ0FIi7LZ68
	 Z3hVDT+eTLQsoPdKoRE/Eq06mtuh8K18APplE4YSNqAOse5h9Z8g+UavRmBPvR/mZ4
	 rrURTcHtkXrwFGqUyt1/KeihDmp/1kIWqRARZADg=
Date: Tue, 03 Nov 2026 23:51:37 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,akpm@linux-foundation.org,
	zhangchujun@cmss.chinamobile.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-use-%u-to-print-the-stack-depot-handle.patch added to mm-new branch
Message-Id: <20261104075138.37A721F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: page_owner: use %u to print the stack depot handle
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-use-%u-to-print-the-stack-depot-handle.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-use-%u-to-print-the-stack-depot-handle.patch

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
From: zhangchujun <zhangchujun@cmss.chinamobile.com>
Subject: mm: page_owner: use %u to print the stack depot handle
Date: Wed,  4 Nov 2026 15:33:28 +0800

stack_record->handle.handle is a depot_stack_handle_t, i.e. an
unsigned 32-bit type. Printing it with %d may display a negative
handle when the extra bits stored in the upper part of the
handle are set, which confuses the users of the page_owner_stacks
debugfs interface.

Use %u instead.

Link: https://lore.kernel.org/20261104073328.1737-1-zhangchujun@cmss.chinamobile.com
Signed-off-by: zhangchujun <zhangchujun@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-use-%u-to-print-the-stack-depot-handle
+++ a/mm/page_owner.c
@@ -1089,7 +1089,7 @@ static int stack_print(struct seq_file *
 			seq_printf(m, " %pS\n", (void *)entries[i]);
 	}
 	if (ctx->flags & STACK_PRINT_FLAG_HANDLE)
-		seq_printf(m, "handle: %d\n", stack_record->handle.handle);
+		seq_printf(m, "handle: %u\n", stack_record->handle.handle);
 	if (ctx->flags & STACK_PRINT_FLAG_PAGES)
 		seq_printf(m, "nr_base_pages: %d\n", nr_base_pages);
 	seq_putc(m, '\n');
_

Patches currently in -mm which might be from zhangchujun@cmss.chinamobile.com are

mm-page_owner-use-%u-to-print-the-stack-depot-handle.patch

