Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8B941744
	for <mm-commits@vger.kernel.org>; Sat, 27 Apr 2024 05:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714196041; cv=none; b=gJvTjKqMjyMOTjqH1JU7zpycUe6hr/Lr7IGuMca4wQF5rBQpuoEGSuDk56wdbGTxGh6/alhUoRCz6t+PrBQ4/fY4F84PdBmII/j0ESRhKzvt8pUj1Tsm74DZkFPu4bP2Hv4DsIDYrAkfTYH+H10E8bkrBsD8xlBpFHc4TCVTK7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714196041; c=relaxed/simple;
	bh=FOwi3LrISTsCnxgkXofMwL6gXv7C60i8xKmYB0SPF+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ioQDZwNz3JAb7+qdKzl6TGxH/tfCfNz5fwcYCkdY+6igub//+2b52wmZe6fUwNUm/B2HvuqMoeuxTYIofuPJb7j0cxQ1pCII+CH/qWSpajC9cVCWgqI25XdbJ+i3lGd4S3wTgDYka7FYrBD8hCDnV6+vPf8aFFzkEhT0L5dZ8wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XbjpkV3R; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XbjpkV3R"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2b0243b8b53so511292a91.1
        for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 22:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714196039; x=1714800839; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OOYc6ngFmfvldENdtb2EqPZSEruub3tYg0VJb3s9owM=;
        b=XbjpkV3REyMBBy0CAcvfxwgGB9BP71t78i+nJnI82++lvT0HCa/lrUgH4xhxbLBsxQ
         a8Qke1JDhG7TjhkSFCcg2UdYoLgRi1QJZ3YIRtyp23g8E5zcXbWay+M0qwFbMdVF/ID5
         ZTj8dElFhzsbSUgypAh2IFvIiNcR0JzEKLdMVZ8ex7On96bn76m6mPptWKSoZUMEedMb
         bDda+CQ3cvMMAxRhQIOeed+Nxdy32MdbKKQR/EMP4dcuxzOoJkr2mN3hPhaZllTeG3ma
         pCW0FK1wFeBzs6u+J9pBMgjIklFqhweESZTJ7UXXxHAYWIWIkQQv7wvg+EB0DFYWHaBu
         ceHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714196039; x=1714800839;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OOYc6ngFmfvldENdtb2EqPZSEruub3tYg0VJb3s9owM=;
        b=JdJCXy7VIZRPG6xUjfGMT5UTXyNqdU5lMOrET4pxNCO6iXW61eyFTwuWgCs4nc9Zqk
         jMO6OjTQGM9R4SI6839ehzPzK2Xx9mazzAvh2F5wsHoh0SyQRWeAMLK45NE4Nk4BrNvI
         CwUL7TSi4z697Cx74tJhk6mEF9d61KKl72h3cb9uq7Nt3zPq2kujSdEu3wd6yl19q+Pv
         P7uDpsgY7zKG5bLwvF4jSAq4o+xAvrznPR2OKHxc1JksRzKY9uP2EcSI7mTjUgaE/tSD
         Epm2MtpU3wyh8KDGKYJfdUo1xguYc810sJ4rFCxFUq4G8CUatety7Dq3LMS9H6/heHkv
         I5Ag==
X-Forwarded-Encrypted: i=1; AJvYcCUS3xxxK7Z0nfMCRLZ3WQmMZXH3CSP437IkVOc9aa6MW65WPJjFmOpq1z4DxYPLh3Lnq6/cpaL1WFkKT84YlrtxPpf6stXZwsfprA==
X-Gm-Message-State: AOJu0YzqwWvC9m16wjWdxFU5huNA3H2W7+OIMMuahbTm7j+mmKE6t0S4
	eBoEDZmH1rjcr3UOJubzBG8sDCloVC5xPY4pnufBlyydElG7zr435jVfvuuF
X-Google-Smtp-Source: AGHT+IETU5elRyaY25NCU6mNudV+qrwS0nVbwfWD+ADTGwyMRmC/scggl7x8W7R8TWeumS8hr6qXEg==
X-Received: by 2002:a17:902:e892:b0:1ea:95f4:579c with SMTP id w18-20020a170902e89200b001ea95f4579cmr5322025plg.1.1714196039176;
        Fri, 26 Apr 2024 22:33:59 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id j5-20020a170903024500b001e5331a0b91sm16350217plh.218.2024.04.26.22.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 22:33:58 -0700 (PDT)
Date: Sat, 27 Apr 2024 13:33:55 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Yury Norov <yury.norov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	jserv@ccns.ncku.edu.tw, n26122115@gs.ncku.edu.tw
Subject: Re: + bitops-optimize-fns-for-improved-performance.patch added to
 mm-nonmm-unstable branch
Message-ID: <ZiyOQ7RtG763rUSJ@visitorckw-System-Product-Name>
References: <20240426190857.BB28FC2BD10@smtp.kernel.org>
 <CAAH8bW9o+d48_84mWXwYkVgMzY+__UxfBnuzauci4qgt1jFZ+Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAH8bW9o+d48_84mWXwYkVgMzY+__UxfBnuzauci4qgt1jFZ+Q@mail.gmail.com>

On Fri, Apr 26, 2024 at 12:48:48PM -0700, Yury Norov wrote:
> On Fri, Apr 26, 2024 at 12:08 PM Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> >
> > The patch titled
> >      Subject: bitops: optimize fns() for improved performance
> > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> >      bitops-optimize-fns-for-improved-performance.patch
> >
> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bitops-optimize-fns-for-improved-performance.patch
> >
> > This patch will later appear in the mm-nonmm-unstable branch at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> >
> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> >
> > The -mm tree is included into linux-next via the mm-everything
> > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > and is updated there every 2-3 working days
> >
> > ------------------------------------------------------
> > From: Kuan-Wei Chiu <visitorckw@gmail.com>
> > Subject: bitops: optimize fns() for improved performance
> > Date: Fri, 26 Apr 2024 11:51:52 +0800
> >
> > The current fns() repeatedly uses __ffs() to find the index of the least
> > significant bit and then clears the corresponding bit using __clear_bit().
> > The method for clearing the least significant bit can be optimized by
> > using word &= word - 1 instead.
> >
> > Typically, the execution time of one __ffs() plus one __clear_bit() is
> > longer than that of a bitwise AND operation and a subtraction.  To improve
> > performance, the loop for clearing the least significant bit has been
> > replaced with word &= word - 1, followed by a single __ffs() operation to
> > obtain the answer.  This change reduces the number of __ffs() iterations
> > from n to just one, enhancing overall performance.
> >
> > The following microbenchmark data, conducted on my x86-64 machine, shows
> > the execution time (in microseconds) required for 1000000 test data
> > generated by get_random_u64() and executed by fns() under different values
> > of n:
> >
> > +-----+---------------+---------------+
> > |  n  |   time_old    |   time_new    |
> > +-----+---------------+---------------+
> > |  0  |     29194     |     25878     |
> > |  1  |     25510     |     25497     |
> > |  2  |     27836     |     25721     |
> > |  3  |     30140     |     25673     |
> > |  4  |     32569     |     25426     |
> > |  5  |     34792     |     25690     |
> > |  6  |     37117     |     25651     |
> > |  7  |     39742     |     25383     |
> > |  8  |     42360     |     25657     |
> > |  9  |     44672     |     25897     |
> > | 10  |     47237     |     25819     |
> > | 11  |     49884     |     26530     |
> > | 12  |     51864     |     26647     |
> > | 13  |     54265     |     28915     |
> > | 14  |     56440     |     28373     |
> > | 15  |     58839     |     28616     |
> > | 16  |     62383     |     29128     |
> > | 17  |     64257     |     30041     |
> > | 18  |     66805     |     29773     |
> > | 19  |     69368     |     33203     |
> > | 20  |     72942     |     33688     |
> > | 21  |     77006     |     34518     |
> > | 22  |     80926     |     34298     |
> > | 23  |     85723     |     35586     |
> > | 24  |     90324     |     36376     |
> > | 25  |     95992     |     37465     |
> > | 26  |    101101     |     37599     |
> > | 27  |    106520     |     37466     |
> > | 28  |    113287     |     38163     |
> > | 29  |    120552     |     38810     |
> > | 30  |    128040     |     39373     |
> > | 31  |    135624     |     40500     |
> > | 32  |    142580     |     40343     |
> > | 33  |    148915     |     40460     |
> > | 34  |    154005     |     41294     |
> > | 35  |    157996     |     41730     |
> > | 36  |    160806     |     41523     |
> > | 37  |    162975     |     42088     |
> > | 38  |    163426     |     41530     |
> > | 39  |    164872     |     41789     |
> > | 40  |    164477     |     42505     |
> > | 41  |    164758     |     41879     |
> > | 42  |    164182     |     41415     |
> > | 43  |    164842     |     42119     |
> > | 44  |    164881     |     42297     |
> > | 45  |    164870     |     42145     |
> > | 46  |    164673     |     42066     |
> > | 47  |    164616     |     42051     |
> > | 48  |    165055     |     41902     |
> > | 49  |    164847     |     41862     |
> > | 50  |    165171     |     41960     |
> > | 51  |    164851     |     42089     |
> > | 52  |    164763     |     41717     |
> > | 53  |    164635     |     42154     |
> > | 54  |    164757     |     41983     |
> > | 55  |    165095     |     41419     |
> > | 56  |    164641     |     42381     |
> > | 57  |    164601     |     41654     |
> > | 58  |    164864     |     41834     |
> > | 59  |    164594     |     41920     |
> > | 60  |    165207     |     42020     |
> > | 61  |    165056     |     41185     |
> > | 62  |    165160     |     41722     |
> > | 63  |    164923     |     41702     |
> > | 64  |    164777     |     41880     |
> > +-----+---------------+---------------+
> 
> Hi Kuan-Wei,
> 
> I didn't receive the original email for some reason...
> We've got a performance test for the function in find_bit_benchmark.
> Can you print before/after here?
> 
> Thanks,
> Yury
>

Hi Yury,

Here are the benchmark results:

Before:
               Start testing find_bit() with random-filled bitmap
[    0.299085] fbcon: Taking over console
[    0.299820] find_next_bit:                  606286 ns, 164169 iterations
[    0.300463] find_next_zero_bit:             641072 ns, 163512 iterations
[    0.300996] find_last_bit:                  531027 ns, 164169 iterations
[    0.305233] find_nth_bit:                  4235859 ns,  16454 iterations
[    0.306434] find_first_bit:                1199357 ns,  16455 iterations
[    0.321616] find_first_and_bit:           15179667 ns,  32869 iterations
[    0.321917] find_next_and_bit:              298836 ns,  73875 iterations
[    0.321918] 
               Start testing find_bit() with sparse bitmap
[    0.321953] find_next_bit:                    7931 ns,    656 iterations
[    0.323201] find_next_zero_bit:            1246980 ns, 327025 iterations
[    0.323210] find_last_bit:                    8000 ns,    656 iterations
[    0.324427] find_nth_bit:                  1213161 ns,    655 iterations
[    0.324813] find_first_bit:                 384747 ns,    656 iterations
[    0.324817] find_first_and_bit:               2220 ns,      1 iterations
[    0.324820] find_next_and_bit:                1831 ns,      1 iterations

After:
               Start testing find_bit() with random-filled bitmap
[    0.305081] fbcon: Taking over console
[    0.306126] find_next_bit:                  854517 ns, 163960 iterations
[    0.307041] find_next_zero_bit:             911725 ns, 163721 iterations
[    0.307711] find_last_bit:                  668261 ns, 163960 iterations
[    0.311160] find_nth_bit:                  3447530 ns,  16372 iterations
[    0.312358] find_first_bit:                1196633 ns,  16373 iterations
[    0.327191] find_first_and_bit:           14830129 ns,  32951 iterations
[    0.327503] find_next_and_bit:              310560 ns,  73719 iterations
[    0.327504] 
               Start testing find_bit() with sparse bitmap
[    0.327539] find_next_bit:                    7633 ns,    656 iterations
[    0.328787] find_next_zero_bit:            1247398 ns, 327025 iterations
[    0.328797] find_last_bit:                    8425 ns,    656 iterations
[    0.330034] find_nth_bit:                  1234044 ns,    655 iterations
[    0.330428] find_first_bit:                 392086 ns,    656 iterations
[    0.330431] find_first_and_bit:               1980 ns,      1 iterations
[    0.330434] find_next_and_bit:                1831 ns,      1 iterations

Some benchmarks seem to have worsened after applying this patch.
However, unless I'm mistaken, the fns() changes should only affect the
results of find_nth_bit, while the others are just random fluctuations.
Should I include the above benchmark data in the commit message and
send a v2 patch?

Additionally, I apologize for you not receiving the email. I received
the following "Message not delivered" email, but I'm unsure if it's
related and what caused the error:

Date: Sat, 27 Apr 2024 04:29:04 +0000 (UTC)
From: do-not-reply@sophosemail.com
To: visitorckw@gmail.com
Subject: Undelivered Mail

This is an automated message from mail service of vivek.yagnik@sophosemail.com

⚠ Message not delivered
------------------ Message details ------------------
From: visitorckw@gmail.com
To: vivek.yagnik@sophosemail.com
Sent: 2024-04-27T04:29:03.000Z
Subject: [PATCH] bitops: Optimize fns() for improved performance
Failure reason:  <vivek.yagnik@sophosemail.com>: host     sophosemail-com.mail.protection.outlook.com[52.101.144.3]
+said: 451 4.4.4     Mail received as unauthenticated, incoming to a recipient domain configured     in a hosted tenant
+which has no mail-enabled subscriptions. ATTR5     [MA1PEPF000072B2.INDPRD01.PROD.OUTLOOK.COM 2024-04-27T04:29:03.836Z
+08DC631634A0BBEB] (in reply to end of DATA command)

Regards,
Kuan-Wei

> > Link: https://lkml.kernel.org/r/20240426035152.956702-1-visitorckw@gmail.com
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
> > Cc: Yury Norov <yury.norov@gmail.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >
> >  include/linux/bitops.h |   12 ++++--------
> >  1 file changed, 4 insertions(+), 8 deletions(-)
> >
> > --- a/include/linux/bitops.h~bitops-optimize-fns-for-improved-performance
> > +++ a/include/linux/bitops.h
> > @@ -254,16 +254,12 @@ static inline unsigned long __ffs64(u64
> >   */
> >  static inline unsigned long fns(unsigned long word, unsigned int n)
> >  {
> > -       unsigned int bit;
> > +       unsigned int i;
> >
> > -       while (word) {
> > -               bit = __ffs(word);
> > -               if (n-- == 0)
> > -                       return bit;
> > -               __clear_bit(bit, &word);
> > -       }
> > +       for (i = 0; word && i < n; i++)
> > +               word &= word - 1;
> >
> > -       return BITS_PER_LONG;
> > +       return word ? __ffs(word) : BITS_PER_LONG;
> >  }
> >
> >  /**
> > _
> >
> > Patches currently in -mm which might be from visitorckw@gmail.com are
> >
> > bitops-optimize-fns-for-improved-performance.patch
> >
