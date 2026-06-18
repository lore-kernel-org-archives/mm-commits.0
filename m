Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7967BA34
	for <mm-commits@vger.kernel.org>; Thu, 18 Jun 2026 19:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781810725; cv=none; b=dDF66iPUnuc1wfswK7+FCnzX+nrCV1K155fX2ccgOfcMwtbRBaQV4ua1eii0WAU5p82v36ix9UzwgwPQmOukacuXEwqTocDDYL+3G20kQNOcXTfPu06LPDIbkdcNN3lLZ1cc26+WnYZXEVhXZyK/cCUbwuA2+J8BXgmM/xmXQPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781810725; c=relaxed/simple;
	bh=MJ/atw/sjJbjgNUE/NJPSlbXr6d7eVv74PHfVe2Qqz0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QfgV1ZriwFKDWkpoN8BJRbBwCKjFateyO+PTw0/c7cvF2WVOfYIsJ6XJcKMt1qBVrcxevNXRMQDTZJbofMUmf74jLJ5yCKMWXM0WqWFNH2aytqhVwA4bKaXYZ6ywYJW6Ses1Cqey3PyGdntgo3NImkpHpUoqY+fS2WP3jwF7TCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4AU9xGx; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4AU9xGx"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-68bac6e24fdso1866187a12.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Jun 2026 12:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1781810722; x=1782415522; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6gl/162Yyv89laBaNydReyy3xdtnaXM6oi2Bko2qKKQ=;
        b=E4AU9xGxnqZai2+JMxBxCKLKGw1fTlbShXmto3YMAJRIrTW1lfXacuH6Y4aZBKqU7V
         5M6guT8XlG8CQoXPPe1gw2BHod+eZxZTdyMD9+rVJYW5HD3WuIoEglCwWExWeKeeED3H
         7wre97/JQEZfmdwxfzFvI0SJ/s37z7gv2S+1A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781810722; x=1782415522;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6gl/162Yyv89laBaNydReyy3xdtnaXM6oi2Bko2qKKQ=;
        b=hedgXZteWHF/c9kKrOHl6oTGlrtDbTJCYg9Hz5q5HfmDO7DMlC6JlkiuCjTWzfrShz
         UQPYMEQ84hmNy39vOnKthfdVBh98QNa18X4lBBZHrrLQXWJhdlYWJFDrPzlHF75a09p9
         sb/qUPHI4gNE42zxX+Xe5jMzNmhQ1+P53gc+2VD6W1F6dAZdf8q2MxHnuVe0u/t/qZEe
         8N/O333ss8k1fjrTgjunnDHbNbcK+SDpHrYLv3U53ISXzIjR5iZPwnPRFPa614t8Xu9p
         9C9+a2x2rYsR8io0WF4n5cUCTo7G4C3usYRxzFiDCohtudvmS/MAuvZvmUMM9KWB8HP/
         E0Hg==
X-Gm-Message-State: AOJu0YxRHMVDiuLX0OhnW30HOKNLXH20V8rzj5W+XWRw4d96r1i7RDWX
	QdLAgBlpib1zPZoomAmx0mc9s7XAa76QMCMOT2cdbQ6jbOcUVYtwQifeiHBSf3hfqS5O7ojMDzS
	5n2Dlcwc=
X-Gm-Gg: AfdE7ck1Gu4RnG9Z5iexX4XzElp6umLFal6K1o2I5lRy1Hjct0bzL4FQPpwuH5nLVmJ
	M4Rf/84JuAyQgt1Xk9fwsGpP9TNrM+RDOoUi5gczw7/ju/q7tX5xf5HVZ31mzwDKqHowQJa0cNx
	5jKR6jDxiacADmcfuvC1rXJsDg5sL3lsNus85kujI34HhURw13Pcg0PD/mTs8SiOl244Ps5cXZV
	wCU6eyZ6oBFjz8W8qhP2EdBm45s0ZVoGcWOjgRNDGD0GeeZRk5XQid8KBLFX662ONXU9nJP0OTl
	4o5ZiW3K8srnbPDTz1VHkxmQ9blp0BMpKoEX5vqb8jPM0KBs49Lf4rgtKb07mk7Brgz9O54xAq4
	d3kbBuDXlBXff4/wQzeXrepLOUe9WDCit3i8reBG7tDwIaRo2X0zn5rIKlIDiFO0hksE7Y0izpj
	iWfwn4K24GyJ/WqQjswHz+vpN38HvW+VJQfqhkebBASgvpiyXSqqY5F3xz2ZIV
X-Received: by 2002:a05:6402:3548:b0:695:837d:529f with SMTP id 4fb4d7f45d1cf-696e5221662mr497935a12.20.1781810722087;
        Thu, 18 Jun 2026 12:25:22 -0700 (PDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-696edc75eb7sm130222a12.2.2026.06.18.12.25.20
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 12:25:21 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c07fd4dc2c8so111256466b.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Jun 2026 12:25:20 -0700 (PDT)
X-Received: by 2002:a17:907:3cc2:b0:bfe:ed06:5a16 with SMTP id
 a640c23a62f3a-c098fed1511mr23022066b.52.1781810719995; Thu, 18 Jun 2026
 12:25:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260618183442.BBCD71F000E9@smtp.kernel.org>
In-Reply-To: <20260618183442.BBCD71F000E9@smtp.kernel.org>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Thu, 18 Jun 2026 12:25:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiQ_10MRYYW+aRfLP4Ah9gDrShOvLESXtz+Q32-9M9Y9w@mail.gmail.com>
X-Gm-Features: AVVi8CfH2WnN-uQgGzjlFiJWeaLtj_2exZjAxtndehiWrEVgNpGbugy27v-vnzY
Message-ID: <CAHk-=wiQ_10MRYYW+aRfLP4Ah9gDrShOvLESXtz+Q32-9M9Y9w@mail.gmail.com>
Subject: Re: + userfaultfd-prevent-registration-of-special-vmas.patch added to
 mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vladimirelitokarev@gmail.com, 
	viro@zeniv.linux.org.uk, stable@vger.kernel.org, peterx@redhat.com, 
	oleg@redhat.com, jack@suse.cz, david@kernel.org, brauner@kernel.org, 
	rppt@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 18 Jun 2026 at 11:34, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Since VM_SPECIAL includes VM_DONTEXPAND which is set but hugetlb, exclude
> hugetlb VMAs from the check for VM_SPECIAL.

This seems bogus.

If somebody sets DONTEXPAND, then that mapping *is* special, and
userfaultfd should not mess with it.

It feels like hugetlbfs is just wrong to do this.

This has caused problems before, see MADV_DODUMP which has that same
"hugetlb doesn't follow the rules" check.

What exactly is it that hugetlbfs wants that DONTEXPAND thing to be?

That said, I don't like the VM_SPECIAL bit mask all that much, because
it doesn't specify *what* kind of "special" it is.

                  Linus
