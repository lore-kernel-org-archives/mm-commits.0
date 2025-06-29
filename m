Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A6B12E7E
	for <mm-commits@vger.kernel.org>; Sun, 29 Jun 2025 01:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751159662; cv=none; b=imGF9YAZVwqb63vWlE1rVwcYWT+xct0J9ByeYVE1j+Rl58Ui8VGnIzKUqvAHIvL7Jvcq3PTbeWwyiYOW2D3W3a3SdGwX+rJfkkH6XNRwH3Byv5OXliJVsW2AO/qUgbflP4DUWMO8qsi1M4GoGFAckuO6igg2t1uwDisidBhQl54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751159662; c=relaxed/simple;
	bh=4IbwGEjY9I10DT3BZp7jmL6n7R9uq0k1O1o3yWqwyb4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SlPh2bpuflljHMVDC2fkDHG+qAceK9iX8gdJpTa8sU/JhmzVLCGSuEpBT5FfhMBeoHaPjh7ELIArzmFPECv0XrcV+9DZpazurf9rRutp6ULOSMHciA6LI1YKFJJ+UmLGSoIGrmER0RzYcemDhZMT0GGz7rLUzauXio4MQM0bhb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ujYkU1HT; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ujYkU1HT"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4a7f5abac0aso266211cf.0
        for <mm-commits@vger.kernel.org>; Sat, 28 Jun 2025 18:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751159659; x=1751764459; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ET2S5EK5aOaGzLbFjOGjctHD36QDrg2Xu8MzzdlH3O4=;
        b=ujYkU1HTOS6U3H/LlZLnedhltpWKo0FD036ZHvhETOgJ74rhYPKPArBZUa6syIDA8c
         pjMWat1ssoWDnkCcrhenmklNuy5zMFHQW6pLabsLagJl8FfFiyXI8U3wEZfJmv6IkMD+
         X9JG+GSQW5LIiCs3qQMwAkdleBF89wSMM7D5X7Fivwf7qrXGf/LhEeaQP6A5nYmb6zdK
         m9/ao2fuZv6udQvITaR9eYnWV0lf4Rq2BVK1Xgo83oLf6VSm7MXLSTMqwq/ypJHPnfNt
         UCH6kYA5y151L/J+NSnMJUNlv7G4aGTBT5rnlnlNq7K55W9/knnhn9N7fjfshdiy436d
         URsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751159659; x=1751764459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ET2S5EK5aOaGzLbFjOGjctHD36QDrg2Xu8MzzdlH3O4=;
        b=orlmPdyHT5awksOB68HUBmWQOQN2ddUqeX7c1JiK1Fp5jnSpO+1jyOKkXkC0xQZcfz
         QWcmATZV1CSNdYyzQIiHn8nK6aNSATFTAWHnYsJvbQXXTz8EplQX+QdqEPuRe1gFIGWe
         vpYQ0YBV+ScPCHQFUfRkRLJPpRmMR3Jcb7A/kJnXbJ7sSJ/qkQKh0TFqoPJUs/P05YiV
         eB3S8w91vH6S0UMGNy5pWs9Yh4JHGG9CHBGlLsntS0jF0vpARZyaoGNTOQl6e86/HHbM
         euTpzcc9q4WviE04L4P3IBXUWgLgv3aak8fGpEyu5i4k2v83EK3aMD7ycaim4QZFH+Ba
         c8Nw==
X-Forwarded-Encrypted: i=1; AJvYcCVv77ASXKvbqQmIPTSMjL2TDzCEl6WLXrue9c8DRvL8Yyyb7fp1F23QuA5+1SsZQqibQs9E7roA9Svl@vger.kernel.org
X-Gm-Message-State: AOJu0YxNQfS3l2lfCdqzQ03ZQuAe2ZsuTl6Z6qIlinyXEsSHjD7V22Xx
	P/fAtRouqKGcDz5vJp8c5Eblqdj6i9D5UzHXDeRMm9XGyBpbdy3ALrwpRsTpCm4o6w3iSgJSWsv
	AeXW6Xi2Ircft5AFZdm5uMoFl8o7brr4MGV6ilaaO
X-Gm-Gg: ASbGnctfiPBquTVoDm8AYDoSaVkHFZRUnD4SL2iCe0z8SGMZhw9WWMrfkT9y0jYe6aB
	btHYvilYQjQv4gFvkwP8wv1zgwpAyGLq3Kl48IMsY58NHQ1s8nRNLBLK+Yy5rIuYsNCPj9DFhBj
	HZi4ZZm7wUcG2yjvRGwqifA8aNzapssQp16ulhZKtLNQ==
X-Google-Smtp-Source: AGHT+IHzMqnqXxwaSWBRxpUP5PDAJ29UuOblI76PizTfEgjLjCBcQ2EotylCQXu32YaEfY4RzXvvSBUcIaWTq4ADhVA=
X-Received: by 2002:a05:622a:5b98:b0:4a7:26d2:5a38 with SMTP id
 d75a77b69052e-4a808ff6f12mr2535971cf.19.1751159659042; Sat, 28 Jun 2025
 18:14:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250624200802.0E2F8C4CEE3@smtp.kernel.org> <33155f3a-e024-4951-9f13-4c9aaefb4972@p183>
In-Reply-To: <33155f3a-e024-4951-9f13-4c9aaefb4972@p183>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 28 Jun 2025 18:14:08 -0700
X-Gm-Features: Ac12FXzqYLQ9NzWkk43RiUoeudjJXEedPcJ0-I_cjyS3Jh2fl7BMOF5A4E0jZAg
Message-ID: <CAJuCfpGxfjpWTpbFg3MJsA3_iKzJJJVya1CRFiZRo9zB17tvKg@mail.gmail.com>
Subject: Re: + selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-remapping.patch
 added to mm-new branch
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	yebin10@huawei.com, willy@infradead.org, vbabka@suse.cz, tjmercier@google.com, 
	shuah@kernel.org, ryan.roberts@arm.com, peterx@redhat.com, paulmck@kernel.org, 
	osalvador@suse.de, mhocko@kernel.org, lorenzo.stoakes@oracle.com, 
	linux@weissschuh.net, liam.howlett@oracle.com, kaleshsingh@google.com, 
	josef@toxicpanda.com, jannh@google.com, hannes@cmpxchg.org, david@redhat.com, 
	christophe.leroy@csgroup.eu, brauner@kernel.org, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 28, 2025 at 7:25=E2=80=AFAM Alexey Dobriyan <adobriyan@gmail.co=
m> wrote:
>
> On Tue, Jun 24, 2025 at 01:08:01PM -0700, Andrew Morton wrote:
> >
> > The patch titled
> >      Subject: selftests/proc: extend /proc/pid/maps tearing test to inc=
lude vma remapping
> > has been added to the -mm mm-new branch.  Its filename is
> >      selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-re=
mapping.patch
> >
> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tr=
ee/patches/selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-=
remapping.patch
> >
> > This patch will later appear in the mm-new branch at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >
> > Note, mm-new is a provisional staging ground for work-in-progress
> > patches, and acceptance into mm-new is a notification for others take
> > notice and to finish up reviews.  Please do not hesitate to respond to
> > review feedback and post updated versions to replace or incrementally
> > fixup patches in mm-new.
> >
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> >
> > *** Remember to use Documentation/process/submit-checklist.rst when tes=
ting your code ***
> >
> > The -mm tree is included into linux-next via the mm-everything
> > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > and is updated there every 2-3 working days
> >
> > ------------------------------------------------------
> > From: Suren Baghdasaryan <surenb@google.com>
> > Subject: selftests/proc: extend /proc/pid/maps tearing test to include =
vma remapping
> > Date: Tue, 24 Jun 2025 12:33:55 -0700
> >
> > Test that /proc/pid/maps does not report unexpected holes in the addres=
s
> > space when we concurrently remap a part of a vma into the middle of
> > another vma.  This remapping results in the destination vma being split
> > into three parts and the part in the middle being patched back from, al=
l
> > done concurrently from under the reader.  We should always see either
> > original vma or the split one with no holes.
> >
> > Link: https://lkml.kernel.org/r/20250624193359.3865351-4-surenb@google.=
com
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Cc: Alexey Dobriyan <adobriyan@gmail.com>
> > Cc: Andrii Nakryiko <andrii@kernel.org>
> > Cc: Christian Brauner <brauner@kernel.org>
> > Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Jann Horn <jannh@google.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Josef Bacik <josef@toxicpanda.com>
> > Cc: Kalesh Singh <kaleshsingh@google.com>
> > Cc: Liam Howlett <liam.howlett@oracle.com>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: Oscar Salvador <osalvador@suse.de>
> > Cc: "Paul E . McKenney" <paulmck@kernel.org>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Ryan Roberts <ryan.roberts@arm.com>
> > Cc: Shuah Khan <shuah@kernel.org>
> > Cc: Thomas Wei=C3=9Fschuh <linux@weissschuh.net>
> > Cc: T.J. Mercier <tjmercier@google.com>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Ye Bin <yebin10@huawei.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >
> >  tools/testing/selftests/proc/proc-pid-vm.c |   92 +++++++++++++++++++
> >  1 file changed, 92 insertions(+)
> >
> > --- a/tools/testing/selftests/proc/proc-pid-vm.c~selftests-proc-extend-=
proc-pid-maps-tearing-test-to-include-vma-remapping
> > +++ a/tools/testing/selftests/proc/proc-pid-vm.c
> > @@ -663,6 +663,95 @@ static void test_maps_tearing_from_resiz
> >       signal_state(mod_info, TEST_DONE);
> >  }
> >
> > +static inline void remap_vma(const struct vma_modifier_info *mod_info)
> > +{
> > +     /*
> > +      * Remap the last page of the next vma into the middle of the vma=
.
> > +      * This splits the current vma and the first and middle parts (th=
e
> > +      * parts at lower addresses) become the last vma objserved in the
> > +      * first page and the first vma observed in the last page.
> > +      */
> > +     assert(mremap(mod_info->next_addr + page_size * 2, page_size,
> > +                   page_size, MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_D=
ONTUNMAP,
> > +                   mod_info->addr + page_size) !=3D MAP_FAILED);
> > +}
> > +
> > +static inline void patch_vma(const struct vma_modifier_info *mod_info)
> > +{
> > +     assert(!mprotect(mod_info->addr + page_size, page_size,
> > +                      mod_info->prot));
> > +}
> > +
> > +static inline void check_remap_result(struct line_content *mod_last_li=
ne,
> > +                                   struct line_content *mod_first_line=
,
> > +                                   struct line_content *restored_last_=
line,
> > +                                   struct line_content *restored_first=
_line)
> > +{
> > +     /* Make sure vmas at the boundaries are changing */
> > +     assert(strcmp(mod_last_line->text, restored_last_line->text) !=3D=
 0);
> > +     assert(strcmp(mod_first_line->text, restored_first_line->text) !=
=3D 0);
> > +}
> > +
> > +static void test_maps_tearing_from_remap(int maps_fd,
> > +                             struct vma_modifier_info *mod_info,
> > +                             struct page_content *page1,
> > +                             struct page_content *page2,
> > +                             struct line_content *last_line,
> > +                             struct line_content *first_line)
> > +{
> > +     struct line_content remapped_last_line;
> > +     struct line_content remapped_first_line;
> > +     struct line_content restored_last_line;
> > +     struct line_content restored_first_line;
> > +
> > +     wait_for_state(mod_info, SETUP_READY);
> > +
> > +     /* re-read the file to avoid using stale data from previous test =
*/
> > +     read_boundary_lines(maps_fd, page1, page2, last_line, first_line)=
;
> > +
> > +     mod_info->vma_modify =3D remap_vma;
> > +     mod_info->vma_restore =3D patch_vma;
> > +     mod_info->vma_mod_check =3D check_remap_result;
> > +
> > +     capture_mod_pattern(maps_fd, mod_info, page1, page2, last_line, f=
irst_line,
> > +                         &remapped_last_line, &remapped_first_line,
> > +                         &restored_last_line, &restored_first_line);
> > +
> > +     /* Now start concurrent modifications for test_duration_sec */
> > +     signal_state(mod_info, TEST_READY);
> > +
> > +     struct line_content new_last_line;
> > +     struct line_content new_first_line;
> > +     struct timespec start_ts, end_ts;
> > +
> > +     clock_gettime(CLOCK_MONOTONIC_COARSE, &start_ts);
> > +     do {
> > +             read_boundary_lines(maps_fd, page1, page2, &new_last_line=
, &new_first_line);
> > +
> > +             /* Check if we read vmas after remapping it */
> > +             if (!strcmp(new_last_line.text, remapped_last_line.text))=
 {
> > +                     /*
> > +                      * The vmas should be consistent with remap resul=
ts,
> > +                      * however if the vma was concurrently restored, =
it
> > +                      * can be reported twice (first as split one, the=
n
> > +                      * as restored one) because we found it as the ne=
xt vma
> > +                      * again. In that case new first line will be the=
 same
> > +                      * as the last restored line.
> > +                      */
> > +                     assert(!strcmp(new_first_line.text, remapped_firs=
t_line.text) ||
> > +                            !strcmp(new_first_line.text, restored_last=
_line.text));
> > +             } else {
> > +                     /* The vmas should be consistent with the origina=
l/resored state */
> > +                     assert(!strcmp(new_last_line.text, restored_last_=
line.text) &&
> > +                            !strcmp(new_first_line.text, restored_firs=
t_line.text));
>
> Pro-tip: long asserts with || can be written as
>
>         if (cond1) {
>         } else if (cond2) {
>         } else {
>                 assert(false);
>         }
>
> and long asserts with && should be written as
>
>         assert(cond1);
>         assert(cond2);
>
> so that you know which one is broken when it happens.

Thanks! I'll revise considering your input.

>
> But maybe not, if you're printing buggy contents anyway.
