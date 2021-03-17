Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB89C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 23:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89FD764EB6
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 23:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbhCQXUW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 19:20:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57682 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229494AbhCQXUD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 19:20:03 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12HN3A6h019233;
        Wed, 17 Mar 2021 19:19:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=/KfeIormv9+X+rtkSKW+FXXUFuZvLUPAZIuBaIryJ7g=;
 b=I5IqVszCwvKMOC1BvleI9d9K5V8nHDMFqeoBRi0GLE6xbcgcfpjGlMLyEZE9T7tixl5g
 VxlGkHz7KlH0p1gW8l+3Py7zLEjgpaSMQNXTksB/6KYzWtqgKI2tLmwYm4ppC6MWcPE5
 iWhJPOYX2ahITrtgv7D0Aie3yy4/BxfKwywDDG61lbGgxjOiv6fKwUok7ED+qrPzxSjt
 cpqUiazO5gUBJiv3PlChqwtuLzli597jQ16RSZoV64BI+X8xouGfUndNjPxebL1qagfO
 hrnjAaLnTUfUn8cloOjExQrgnzDNNK7dZK1QxioAFstABHP7z9GZ/MoK3y6mOFfh7jS5 PQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37bnrs9hvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Mar 2021 19:19:16 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12HN3wRR021264;
        Wed, 17 Mar 2021 19:19:15 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37bnrs9hur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Mar 2021 19:19:15 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12HNCojj021393;
        Wed, 17 Mar 2021 23:19:15 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 378ubtrqan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Mar 2021 23:19:14 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12HNJEkI32244006
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 23:19:14 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 002C67805C;
        Wed, 17 Mar 2021 23:19:13 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 199CC78066;
        Wed, 17 Mar 2021 23:19:08 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.80.237.238])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 17 Mar 2021 23:19:07 +0000 (GMT)
Message-ID: <42da5805da8dad56818d2047b2e64c20ec7d030d.camel@linux.ibm.com>
Subject: Re: + mm-add-definition-of-pmd_page_order.patch added to -mm tree
From:   James Bottomley <jejb@linux.ibm.com>
To:     Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org
Cc:     arnd@arndb.de, bp@alien8.de, catalin.marinas@arm.com, cl@linux.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, elena.reshetova@intel.com, guro@fb.com,
        hagen@jauu.net, hpa@zytor.com, kirill@shutemov.name,
        luto@kernel.org, mark.rutland@arm.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, mtk.manpages@gmail.com,
        palmer@dabbelt.com, palmerdabbelt@google.com,
        paul.walmsley@sifive.com, peterz@infradead.org,
        rick.p.edgecombe@intel.com, rppt@linux.ibm.com,
        shakeelb@google.com, shuah@kernel.org, tglx@linutronix.de,
        tycho@tycho.ws, viro@zeniv.linux.org.uk, will@kernel.org
Date:   Wed, 17 Mar 2021 16:19:06 -0700
In-Reply-To: <20210317225402.GH3420@casper.infradead.org>
References: <20210317221512.A39Ft3LQk%akpm@linux-foundation.org>
         <20210317225402.GH3420@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-17_13:2021-03-17,2021-03-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=505 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103170163
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 2021-03-17 at 22:54 +0000, Matthew Wilcox wrote:
> On Wed, Mar 17, 2021 at 03:15:12PM -0700, akpm@linux-foundation.org
> wrote:
> > Several architectures already have definition of PMD_ORDER as the
> > size of second level page table, so to avoid conflict with these
> > definitions use PMD_PAGE_ORDER name and update DAX respectively.
> 
> I thought I NACKed this patch already?

I don't think anyone understands why.  DAX won't build on several
architectures, including parisc, because of this existing symbol clash.

> The architectures should be updated to not use PMD_ORDER.  PMD_ORDER
> is clearly the right name for what is now PMD_PAGE_ORDER.  The
> architectures should be using PMD_ALLOC_ORDER or some such.

Well I had a patch renaming the dax specific one to DAX_PMD_ORDER which
you also didn't like.  Why don't you just propose the patch you do like
because this is a build failure on several architectures currently.

I don't really care what colour the bike shed is ... I do care that my
builds fail.

James



