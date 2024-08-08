Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A42E15A85E
	for <mm-commits@vger.kernel.org>; Thu,  8 Aug 2024 22:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723155556; cv=none; b=NAx+k5qY8/CZsfD89MjyTzMJ6lsgYPAsU+ahSdS9tZaAKQY2AeC6QT8u7SiqugfVwKkmPwpAKx/EII+sMAQPfgs3FcumzSG0BhELku4A41arxrEsf3wjZn5s784hoPZtkIHdTjHfWEXV6opcfV6fNmHLjz3ZtM9TVFDwWgauOsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723155556; c=relaxed/simple;
	bh=h1o35ozLX6jE83bkerUSVSegPbfvpeQDmPxzY0SPkVo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ly/RtDVHw/1PC57SkqsAP/3+wxiDoApLr90WHe5cnV5NchSxXmsDHxKAvQ3VyL4Z+tE6L8pfLh3f89H3g6wGNEmSeOQcPzm/pJhIxLg7M03FiwfpG6kzcPC0T+26mCH44Bya93TVj61Ldz6azLy1qQHpWm64a7FJm3dUtuqEWSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=SZF4rXzJ; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="SZF4rXzJ"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7093d565310so1048733a34.2
        for <mm-commits@vger.kernel.org>; Thu, 08 Aug 2024 15:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1723155553; x=1723760353; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wFhTdPmJT39rYZfT2DukWDExZBxYSWIOL4WMbFh4V5o=;
        b=SZF4rXzJ2ay4YaKbLFESSo6swS97IJYbEhBP7/FTM40HQdKdu6pvnEZ5DtOMlBz0by
         Wca6pjX/FEdjvHy6I7oSfQ4e0pq/ipoC5/jhrFEqLJcJjzqwG1m4MyoUhRBZInl3bp55
         fvjLnmJly5VmGR7TeQXOzEllL02UcFvOe/yNo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723155553; x=1723760353;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wFhTdPmJT39rYZfT2DukWDExZBxYSWIOL4WMbFh4V5o=;
        b=FmXkiigO8wXMbGM0Tay3ENSEuyaxp5s26NSVNR6iHjfAaC4asrkLbRVGTtNWtnStMB
         3PMsjtinzQeYqcqL04JNjBmJ0pwExdJSh+erTgxv3yJv4C/h+I0d/WfGxdbAXudldYms
         d3hHDsvuWFo3OnEx33QoGNYJVSsdAGTPE0THlwY3kv9MUZ3zK0UvrRfkqfzHljWeVAEF
         GJVTshFvFskEwi1yNIpBePKfioGBGuB4uvIFd7kxSR9Jr+v61/fALdkv+i+qyAv1ZxIS
         ZqxgFSjnbm6TCJ266s927mwZdN+JqzKLCNGJPAw02+rGx6Qk1ssvigK+AVi59wNgf+by
         +5bQ==
X-Gm-Message-State: AOJu0YypZ/jQusK6ByWVHudJoYVDXDOW6iHmjVBD1JbqQU8v9rnKo1El
	+V92K1EbdP+iuaJUj9Bw2gU8sVaNxTtqlekiE1j+v0axFVL/zG3zPnnSczFVL8Ai1tSoWOiRL38
	30tfNDBBETJotVnV586NjFJbd5A6pSlx8sDvo
X-Google-Smtp-Source: AGHT+IGRpjcyGTEBtmGb3gTnIkb6dRWucen9gDy6ZXe8E05TJubRW4WOItKZXVTil1+Cdn4wQ/scISBrDN+VxjRtNcA=
X-Received: by 2002:a05:6870:96a7:b0:24f:dd11:4486 with SMTP id
 586e51a60fabf-2692b7ba04dmr3434848fac.36.1723155553504; Thu, 08 Aug 2024
 15:19:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240807212933.88C51C32781@smtp.kernel.org>
In-Reply-To: <20240807212933.88C51C32781@smtp.kernel.org>
From: Jeff Xu <jeffxu@chromium.org>
Date: Thu, 8 Aug 2024 15:19:01 -0700
Message-ID: <CABi2SkUnmVwfo9pwjQrHrwvUW3W1COqJxwQj1+avepcTaW4n9Q@mail.gmail.com>
Subject: Re: + selftests-mm-add-mseal-test-for-no-discard-madvise-fix.patch
 added to mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, shuah@kernel.org, Liam.Howlett@oracle.com, 
	kees@kernel.org, pedro.falcato@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 7, 2024 at 2:29=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
>
> The patch titled
>      Subject: fixup! selftests/mm: Add mseal test for no-discard madvise
> has been added to the -mm mm-unstable branch.  Its filename is
>      selftests-mm-add-mseal-test-for-no-discard-madvise-fix.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/selftests-mm-add-mseal-test-for-no-discard-madvise-fix.patch
>
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: Pedro Falcato <pedro.falcato@gmail.com>
> Subject: fixup! selftests/mm: Add mseal test for no-discard madvise
> Date: Wed, 7 Aug 2024 21:37:24 +0100
>
> Adjust the mseal test's plan.
>
> Link: https://lkml.kernel.org/r/20240807203724.2686144-1-pedro.falcato@gm=
ail.com
> Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
> Cc: Jeff Xu <jeffxu@chromium.org>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Tested-by: Jeff Xu <jeffxu@chromium.org>
    Reviewed-by: Jeff Xu <jeffxu@chromium.org>

> ---
>
>  tools/testing/selftests/mm/mseal_test.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-add-mseal-test=
-for-no-discard-madvise-fix
> +++ a/tools/testing/selftests/mm/mseal_test.c
> @@ -1775,7 +1775,7 @@ int main(int argc, char **argv)
>         if (!pkey_supported())
>                 ksft_print_msg("PKEY not supported\n");
>
> -       ksft_set_plan(80);
> +       ksft_set_plan(82);
>
>         test_seal_addseal();
>         test_seal_unmapped_start();
> _
>
> Patches currently in -mm which might be from pedro.falcato@gmail.com are
>
> mseal-fix-is_madv_discard.patch
> selftests-mm-add-mseal-test-for-no-discard-madvise.patch
> selftests-mm-add-mseal-test-for-no-discard-madvise-fix.patch
>
