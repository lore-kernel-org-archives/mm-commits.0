Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEE21A9FBD
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343080; cv=none; b=Z9YZRB3jeCxIxSF9wFDawc2RXbLFN4Ups3NSCot4x2exZCT3xS7RyAeJ1DfQk/pPqs8FmeGzHL+qohpLKoOnnicMseDQSTYBNUMQwNAcrsu3mV2YwXcQTZkevSpkWi1SiVuAYZtdu+2TqklQBJGDgBKJKh2IOWFSJ72EZXmTJ2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343080; c=relaxed/simple;
	bh=+/zSSWpN5YkJewvAyxIYJRV1hUIS/rBIU6tFH7dQyD4=;
	h=Date:To:From:Subject:Message-Id; b=MhpgEvISYy12pc+9OLEiQ0VmBAzrPBPwYKAmFTH5jD9SV2HIPg9eaD2pipcDexpKNWh7/2JR57qEa4FFXZ/sf5gS9a6fS6qrTglXkgy+H+0lTOFKpsemroKGpharYM/nH1En081QJRG1F9FDP9eoJI3Suhwoajt1AVp7UvYsVzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UDryhq97; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UDryhq97"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE39C113D0;
	Mon, 17 Nov 2025 01:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343080;
	bh=+/zSSWpN5YkJewvAyxIYJRV1hUIS/rBIU6tFH7dQyD4=;
	h=Date:To:From:Subject:From;
	b=UDryhq97fJxeDTJfmWR0dQ+fVbn1Yx4U1Law3FkRGXnmwWRjwhurOMPx6wJDS3Mnf
	 gOIRokpfVAHPHMQ+loX/FQP+RMHildn/cB97TJxGBA8Xa2sSUcV03C9DMF41kvGodK
	 jMpoJUKqleMUjUKYkQLkurFyObfsT65btAYheVkk=
Date: Sun, 16 Nov 2025 17:31:19 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,mhocko@suse.com,mhocko@kernel.org,glider@google.com,elver@google.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_vmalloc-remove-xfail-condition-check.patch removed from -mm tree
Message-Id: <20251117013120.2AE39C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_vmalloc: remove xfail condition check
has been removed from the -mm tree.  Its filename was
     lib-test_vmalloc-remove-xfail-condition-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: lib/test_vmalloc: remove xfail condition check
Date: Tue, 7 Oct 2025 14:20:27 +0200

A test marked with "xfail = true" is expected to fail but that does not
mean it is predetermined to fail.  Remove "xfail" condition check for
tests which pass successfully.

Link: https://lkml.kernel.org/r/20251007122035.56347-3-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_vmalloc.c~lib-test_vmalloc-remove-xfail-condition-check
+++ a/lib/test_vmalloc.c
@@ -500,7 +500,7 @@ static int test_func(void *private)
 		for (j = 0; j < test_repeat_count; j++) {
 			ret = test_case_array[index].test_func();
 
-			if (!ret && !test_case_array[index].xfail)
+			if (!ret)
 				t->data[index].test_passed++;
 			else if (ret && test_case_array[index].xfail)
 				t->data[index].test_xfailed++;
_

Patches currently in -mm which might be from urezki@gmail.com are


