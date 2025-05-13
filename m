Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3B81EF375
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119330; cv=none; b=Xbbd3xImAKDI3JdN6HBb3AzZ2m4SdXbPdvU66hsfDpx6cl80DcJ0TcJl5B4gUNz2jx9ReA7H4lLlT35Y13ID8Hail6DwUkfdVq6xtuK20LQmMweT6XjEJygv94RrAIxFts3vvIHFqi04Su5evtDI1gP17Gvz1zIYbkJibXwurrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119330; c=relaxed/simple;
	bh=8KPRzA7+0P+z6g4SoEk2b1td2SSh3EoMW+Lpx6/fmFs=;
	h=Date:To:From:Subject:Message-Id; b=J36zyaqF1mB3EfJkDbyxqcLAIhGU/cc2uUH6djGewFWyqBmmoMDkcrL+XE/qalzFqcSnzmX/RM0Yhr+jHf8ZghgZnSl3+4F9cAtYCowp+eQTdWsZ1UGZdvhdNRHMKGAjFm7AqmSIuUIvGPQM1wr9nYR53brw2J2Ajy8Pkfu52Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MXjkfpkw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MXjkfpkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9714FC4CEE4;
	Tue, 13 May 2025 06:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119330;
	bh=8KPRzA7+0P+z6g4SoEk2b1td2SSh3EoMW+Lpx6/fmFs=;
	h=Date:To:From:Subject:From;
	b=MXjkfpkw7gHiz4e2OH4nD19fWgDkJIyJdrVpXzq0Cv0I63gfLbjDdJwHW95Lb7sBJ
	 tQ0ONnTMZimiAvdFfibsJdOFfi/yd8+g989YJqot3IlZ1dF5bjDITSA/V8RYe7dVev
	 kV5asWRi7ADLZAN+V9RWjsaRpFGrTb6X0yZBvrE4=
Date: Mon, 12 May 2025 23:55:30 -0700
To: mm-commits@vger.kernel.org,vivek.kasireddy@intel.com,david@redhat.com,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-remove-page_folio-in-memfd_pin_folios.patch removed from -mm tree
Message-Id: <20250513065530.9714FC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: remove page_folio() in memfd_pin_folios()
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-page_folio-in-memfd_pin_folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/gup: remove page_folio() in memfd_pin_folios()
Date: Tue, 29 Apr 2025 18:00:59 -0700

We can get the folio directly from the folio batch, so remove the
unnecessary page_folio() call.

Link: https://lkml.kernel.org/r/20250430010059.892632-3-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-remove-page_folio-in-memfd_pin_folios
+++ a/mm/gup.c
@@ -3641,7 +3641,7 @@ long memfd_pin_folios(struct file *memfd
 			}
 
 			for (i = 0; i < nr_found; i++) {
-				folio = page_folio(&fbatch.folios[i]->page);
+				folio = fbatch.folios[i];
 
 				if (try_grab_folio(folio, 1, FOLL_PIN)) {
 					folio_batch_release(&fbatch);
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


