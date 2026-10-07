Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71752853E0
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334135; cv=none; b=tczrJUt+NExllSeb4PmUGL+sMMZcw7jfUzo5MGJxrvAEN0puijGsNam8O2ht5poJ1eCZu1P8i3YxzKZaPgFD14QK+pPANwaw8jd/U6kGO92ZhSA2m18K9+BWMntIT8j/PAtLcnm7eQDfU69XFj9c+OnCxSDSGZ4twTKu9CR6g4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334135; c=relaxed/simple;
	bh=4TJbp+GcZ8URKfRLz3M2OwHZXACQ8WJZaZ+nr0nfwlc=;
	h=Date:To:From:Subject:Message-Id; b=Tg1f6nMLeEdrQXWT/u/UNF394E+yd6LwvoqklFKT59oCEIm158PAbat2BccM2i5WJ9SIWJzAqDR0LdDxOsYO1PDQo2SePYbDqEQyrQG4VTZBHiErcwuF4uVkOM5Az/f9f28k9s/mpWP1kdGsESvcgmKU030csWDKqKAw5ogI/jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HgroJe3u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HgroJe3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D2B1F0089B;
	Wed,  7 Oct 2026 00:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334134;
	bh=lIJqLWKY2Vv+c7OKcxvXrYC7xdYnB0XJWSReHZxcq4A=;
	h=Date:To:From:Subject;
	b=HgroJe3uc1V3gavV/ZQGHhdIU45kJuyPfkGuLSmkusrRiEBQC1sF2gd3WE7CFJNQ8
	 wbAfNJvJprBD6CUxil3ztwbhBd69bxjZ+yFedYzBBS7SoFzn1ry9sZ9/7fN5NQ1ZiT
	 qCXJYdHLRm/0VwdljT+BdUuRdWBu8rvM+werMyHE=
Date: Tue, 06 Oct 2026 17:48:54 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,anshumantewari123@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-line-buffer-leak-in-mremap_test-is_range_mapped.patch removed from -mm tree
Message-Id: <20261007004854.79D2B1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix line buffer leak in mremap_test is_range_mapped()
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-line-buffer-leak-in-mremap_test-is_range_mapped.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman <anshumantewari123@gmail.com>
Subject: selftests/mm: fix line buffer leak in mremap_test is_range_mapped()
Date: Wed, 26 Aug 2026 11:43:00 +0530

is_range_mapped() uses getline() to read /proc/self/maps line by line, but
never frees the buffer it allocates.  Every exit path (parse failure,
match found, or reaching EOF) returns without calling free(line), leaking
the buffer on each call.  The function is called multiple times in this
test, so the leak accumulates across calls.

Free line before returning.

Link: https://lore.kernel.org/20260826061300.14038-1-anshumantewari123@gmail.com
Signed-off-by: Anshuman <anshumantewari123@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 tools/testing/selftests/mm/mremap_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-fix-line-buffer-leak-in-mremap_test-is_range_mapped
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -156,6 +156,7 @@ static bool is_range_mapped(FILE *maps_f
 		}
 	}
 
+	free(line);
 	return success;
 }
 
_

Patches currently in -mm which might be from anshumantewari123@gmail.com are


