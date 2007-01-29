From: akpm@osdl.org
Subject: + drivers-isdn-hardware-eicon-convert-to-generic-boolean-values.patch added to -mm tree
Date: Sun, 28 Jan 2007 16:03:07 -0800
Message-ID: <200701290003.l0T037KC006595@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42715 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932997AbXA2ADW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Jan 2007 19:03:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ricknu-0@student.ltu.se, kkeil@suse.de


The patch titled
     drivers/isdn/hardware/eicon/: convert to generic boolean-values
has been added to the -mm tree.  Its filename is
     drivers-isdn-hardware-eicon-convert-to-generic-boolean-values.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/isdn/hardware/eicon/: convert to generic boolean-values
From: Richard Knutsson <ricknu-0@student.ltu.se>

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/isdn/hardware/eicon/capifunc.c |    4 
 drivers/isdn/hardware/eicon/di.c       |   16 -
 drivers/isdn/hardware/eicon/message.c  |  360 +++++++++++------------
 drivers/isdn/hardware/eicon/os_pri.c   |    4 
 drivers/isdn/hardware/eicon/platform.h |    8 
 5 files changed, 192 insertions(+), 200 deletions(-)

diff -puN drivers/isdn/hardware/eicon/capifunc.c~drivers-isdn-hardware-eicon-convert-to-generic-boolean-values drivers/isdn/hardware/eicon/capifunc.c
--- a/drivers/isdn/hardware/eicon/capifunc.c~drivers-isdn-hardware-eicon-convert-to-generic-boolean-values
+++ a/drivers/isdn/hardware/eicon/capifunc.c
@@ -187,7 +187,7 @@ static diva_card *find_card_by_ctrl(word
  */
 void *TransmitBufferSet(APPL * appl, dword ref)
 {
-	appl->xbuffer_used[ref] = TRUE;
+	appl->xbuffer_used[ref] = true;
 	DBG_PRV1(("%d:xbuf_used(%d)", appl->Id, ref + 1))
 	    return (void *) ref;
 }
@@ -202,7 +202,7 @@ void *TransmitBufferGet(APPL * appl, voi
 
 void TransmitBufferFree(APPL * appl, void *p)
 {
-	appl->xbuffer_used[(dword) p] = FALSE;
+	appl->xbuffer_used[(dword) p] = false;
 	DBG_PRV1(("%d:xbuf_free(%d)", appl->Id, ((dword) p) + 1))
 }
 
diff -puN drivers/isdn/hardware/eicon/di.c~drivers-isdn-hardware-eicon-convert-to-generic-boolean-values drivers/isdn/hardware/eicon/di.c
--- a/drivers/isdn/hardware/eicon/di.c~drivers-isdn-hardware-eicon-convert-to-generic-boolean-values
+++ a/drivers/isdn/hardware/eicon/di.c
@@ -173,16 +173,16 @@ void pr_out(ADAPTER * a)
         xdi_xlog_request (XDI_A_NR(a), this->Id, this->ReqCh, this->MInd,
                           a->IdTypeTable[this->No]);
         a->ram_out(a, &ReqOut->Req, this->MInd);
-        more = TRUE;
+        more = true;
       }
       else {
         xdi_xlog_request (XDI_A_NR(a), this->Id, this->ReqCh, this->Req,
                           a->IdTypeTable[this->No]);
         this->More |=XMOREF;
         a->ram_out(a, &ReqOut->Req, this->Req);
-        more = FALSE;
+        more = false;
         if (a->FlowControlIdTable[this->ReqCh] == this->Id)
-          a->FlowControlSkipTable[this->ReqCh] = TRUE;
+          a->FlowControlSkipTable[this->ReqCh] = true;
         /*
            Note that remove request was sent to the card
            */
@@ -311,7 +311,7 @@ byte pr_dpc(ADAPTER * a)
         /* are marked RNR                                           */
       if(RNRId && RNRId==a->ram_in(a, &IndIn->IndId)) {
         a->ram_out(a, &IndIn->Ind, 0);
-        a->ram_out(a, &IndIn->RNR, TRUE);
+        a->ram_out(a, &IndIn->RNR, true);
       }
       else {
         Ind = a->ram_in(a, &IndIn->Ind);
@@ -331,7 +331,7 @@ byte pr_dpc(ADAPTER * a)
             dtrc(dprintf("RNR"));
             a->ram_out(a, &IndIn->Ind, 0);
             RNRId = a->ram_in(a, &IndIn->IndId);
-            a->ram_out(a, &IndIn->RNR, TRUE);
+            a->ram_out(a, &IndIn->RNR, true);
           }
         }
       }
@@ -340,7 +340,7 @@ byte pr_dpc(ADAPTER * a)
     }
     a->ram_out(a, &PR_RAM->IndOutput, 0);
   }
-  return FALSE;
+  return false;
 }
 byte scom_test_int(ADAPTER * a)
 {
@@ -399,7 +399,7 @@ byte isdn_rc(ADAPTER * a,
           return (0);
         }
         if (extended_info_type == DIVA_RC_TYPE_REMOVE_COMPLETE)
-          a->RcExtensionSupported = TRUE;
+          a->RcExtensionSupported = true;
       }
       a->misc_flags_table[e_no] &= ~DIVA_MISC_FLAGS_REMOVE_PENDING;
       a->misc_flags_table[e_no] &= ~DIVA_MISC_FLAGS_NO_RC_CANCELLING;
@@ -428,7 +428,7 @@ byte isdn_rc(ADAPTER * a,
     }
     if (Rc==OK_FC) {
       a->FlowControlIdTable[Ch] = Id;
-      a->FlowControlSkipTable[Ch] = FALSE;
+      a->FlowControlSkipTable[Ch] = false;
       this->Rc = Rc;
       this->More &= ~(XBUSY | XMOREC);
       this->complete=0xff;
diff -puN drivers/isdn/hardware/eicon/message.c~drivers-isdn-hardware-eicon-convert-to-generic-boolean-values drivers/isdn/hardware/eicon/message.c
--- a/drivers/isdn/hardware/eicon/message.c~drivers-isdn-hardware-eicon-convert-to-generic-boolean-values
+++ a/drivers/isdn/hardware/eicon/message.c
@@ -253,7 +253,7 @@ extern APPL   * application;
 
 
 
-static byte remove_started = FALSE;
+static byte remove_started = false;
 static PLCI dummy_plci;
 
 
@@ -456,12 +456,12 @@ word api_put(APPL   * appl, CAPI_MSG   *
 
         return _QUEUE_FULL;
       }
-      c = FALSE;
+      c = false;
       if ((((byte   *) msg) < ((byte   *)(plci->msg_in_queue)))
        || (((byte   *) msg) >= ((byte   *)(plci->msg_in_queue)) + sizeof(plci->msg_in_queue)))
       {
         if (plci->msg_in_write_pos != plci->msg_in_read_pos)
-          c = TRUE;
+          c = true;
       }
       if (msg->header.command == _DATA_B3_R)
       {
@@ -506,13 +506,13 @@ word api_put(APPL   * appl, CAPI_MSG   *
 
             return _QUEUE_FULL;
           }
-          c = TRUE;
+          c = true;
         }
       }
       else
       {
         if (plci->req_in || plci->internal_command)
-          c = TRUE;
+          c = true;
         else
         {
           plci->command = msg->header.command;
@@ -626,10 +626,10 @@ word api_parse(byte   * msg, word length
       break;
     }
 
-    if(p>length) return TRUE;
+    if(p>length) return true;
   }
   if(parms) parms[i].info = NULL;
-  return FALSE;
+  return false;
 }
 
 void api_save_msg(API_PARSE   *in, byte *format, API_SAVE   *out)
@@ -687,7 +687,7 @@ word api_remove_start(void)
   word j;
 
   if(!remove_started) {
-    remove_started = TRUE;
+    remove_started = true;
     for(i=0;i<max_adapter;i++) {
       if(adapter[i].request) {
         for(j=0;j<adapter[i].max_plci;j++) {
@@ -1080,7 +1080,7 @@ static void plci_remove(PLCI   * plci)
       send_req(plci);
     }
   }
-  ncci_remove (plci, 0, FALSE);
+  ncci_remove (plci, 0, false);
   plci_free_msg_in_queue (plci);
 
   plci->channels = 0;
@@ -1226,7 +1226,7 @@ byte connect_req(dword Id, word Number, 
       Id = ((word)1<<8)|a->Id;
       sendf(appl,_CONNECT_R|CONFIRM,Id,Number,"w",0);
       sendf(appl, _DISCONNECT_I, Id, 0, "w", _L1_ERROR);
-      return FALSE;
+      return false;
     }
     Info = _OUT_OF_PLCI;
     if((i=get_plci(a)))
@@ -1330,7 +1330,7 @@ byte connect_req(dword Id, word Number, 
       plci->command = _CONNECT_R;
       plci->number = Number;
       /* x.31 or D-ch free SAPI in LinkLayer? */
-      if(ch==1 && LinkLayer!=3 && LinkLayer!=12) noCh = TRUE;
+      if(ch==1 && LinkLayer!=3 && LinkLayer!=12) noCh = true;
       if((ch==0 || ch==2 || noCh || ch==3 || ch==4) && !Info)
       {
         /* B-channel used for B3 connections (ch==0), or no B channel    */
@@ -1381,7 +1381,7 @@ byte connect_req(dword Id, word Number, 
             plci->command = 0;
             dbug(1,dprintf("Spoof"));
             send_req(plci);
-            return FALSE;
+            return false;
           }
           if(ch==4)add_p(plci,CHI,p_chi);
           add_s(plci,CPN,&parms[1]);
@@ -1395,11 +1395,11 @@ byte connect_req(dword Id, word Number, 
             plci->appl = appl;
             sig_req(plci,LISTEN_REQ,0);
             send_req(plci);
-            return FALSE;
+            return false;
           }
         }
         send_req(plci);
-        return FALSE;
+        return false;
       }
       plci->Id = 0;
     }
@@ -1571,7 +1571,7 @@ byte connect_res(dword Id, word Number, 
 byte connect_a_res(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plci, APPL   * appl, API_PARSE * msg)
 {
   dbug(1,dprintf("connect_a_res"));
-  return FALSE;
+  return false;
 }
 
 byte disconnect_req(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plci, APPL   * appl, API_PARSE * msg)
@@ -1624,9 +1624,9 @@ byte disconnect_req(dword Id, word Numbe
       }
     }
 
-  if(!appl)  return FALSE;
+  if(!appl)  return false;
   sendf(appl, _DISCONNECT_R|CONFIRM, Id, Number, "w",Info);
-  return FALSE;
+  return false;
 }
 
 byte disconnect_res(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plci, APPL   * appl, API_PARSE * msg)
@@ -1702,7 +1702,7 @@ byte listen_req(dword Id, word Number, D
         "w",Info);
 
   if (a) listen_check(a);
-  return FALSE;
+  return false;
 }
 
 byte info_req(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plci, APPL   * appl, API_PARSE * msg)
@@ -1739,7 +1739,7 @@ byte info_req(dword Id, word Number, DIV
       add_s(plci,KEY,&ai_parms[1]);
       sig_req(plci,INFO_REQ,0);
       send_req(plci);
-      return FALSE;
+      return false;
     }
 
     if(plci->State && ai_parms[2].length)
@@ -1769,7 +1769,7 @@ byte info_req(dword Id, word Number, DIV
     if((i=get_plci(a)))
     {
       rc_plci = &a->plci[i-1];
-      appl->NullCREnable  = TRUE;
+      appl->NullCREnable  = true;
       rc_plci->internal_command = C_NCR_FAC_REQ;
       rc_plci->appl = appl;
       add_p(rc_plci,CAI,"\x01\x80");
@@ -1788,7 +1788,7 @@ byte info_req(dword Id, word Number, DIV
       add_ai(rc_plci, &msg[1]);
       sig_req(rc_plci,NCR_FACILITY,0);
       send_req(rc_plci);
-      return FALSE;
+      return false;
      /* for application controlled supplementary services    */
     }
   }
@@ -1811,13 +1811,13 @@ byte info_req(dword Id, word Number, DIV
           Number,
           "w",Info);
   }
-  return FALSE;
+  return false;
 }
 
 byte info_res(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plci, APPL   * appl, API_PARSE * msg)
 {
   dbug(1,dprintf("info_res"));
-  return FALSE;
+  return false;
 }
 
 byte alert_req(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plci, APPL   * appl, API_PARSE * msg)
@@ -1828,7 +1828,7 @@ byte alert_req(dword Id, word Number, DI
   dbug(1,dprintf("alert_req"));
 
   Info = _WRONG_IDENTIFIER;
-  ret = FALSE;
+  ret = false;
   if(plci) {
     Info = _ALERT_IGNORED;
     if(plci->State!=INC_CON_ALERT) {
@@ -1922,7 +1922,7 @@ byte facility_req(dword Id, word Number,
             rplci->appl = appl;
             sig_req(rplci,S_SUPPORTED,0);
             send_req(rplci);
-            return FALSE;
+            return false;
             break;
 
           case S_LISTEN:
@@ -1972,7 +1972,7 @@ byte facility_req(dword Id, word Number,
               add_s(plci,CAI,&ss_parms[1]);
               sig_req(plci,CALL_HOLD,0);
               send_req(plci);
-              return FALSE;
+              return false;
             }
             else Info = 0x3010;                    /* wrong state           */
             break;
@@ -1997,13 +1997,13 @@ byte facility_req(dword Id, word Number,
                 plci->internal_command = BLOCK_PLCI;
                 plci->command = 0;
                 dbug(1,dprintf("Spoof"));
-                return FALSE;
+                return false;
               }
               else
               {
                 sig_req(plci,CALL_RETRIEVE,0);
                 send_req(plci);
-                return FALSE;
+                return false;
               }
             }
             else Info = 0x3010;                    /* wrong state           */
@@ -2123,7 +2123,7 @@ byte facility_req(dword Id, word Number,
               add_p(plci,CAI,cai);
               sig_req(plci,S_SERVICE,0);
               send_req(plci);
-              return FALSE;
+              return false;
             }
             else Info = 0x3010;                    /* wrong state           */
             break;
@@ -2265,7 +2265,7 @@ byte facility_req(dword Id, word Number,
               add_p(rplci,CAI,cai);
               sig_req(rplci,S_SERVICE,0);
               send_req(rplci);
-              return FALSE;
+              return false;
             }
             else
             {
@@ -2291,14 +2291,14 @@ byte facility_req(dword Id, word Number,
             ss_parms[3].info[3] = (byte)GET_WORD(&(ss_parms[2].info[0]));
             plci->command = 0;
             plci->internal_command = CD_REQ_PEND;
-            appl->CDEnable = TRUE;
+            appl->CDEnable = true;
             cai[0] = 1;
             cai[1] = CALL_DEFLECTION;
             add_p(plci,CAI,cai);
             add_p(plci,CPN,ss_parms[3].info);
             sig_req(plci,S_SERVICE,0);
             send_req(plci);
-            return FALSE;
+            return false;
             break;
 
           case S_CALL_FORWARDING_START:
@@ -2337,7 +2337,7 @@ byte facility_req(dword Id, word Number,
             add_p(rplci,CPN,ss_parms[6].info);
             sig_req(rplci,S_SERVICE,0);
             send_req(rplci);
-            return FALSE;
+            return false;
             break;
 
           case S_INTERROGATE_DIVERSION:
@@ -2456,7 +2456,7 @@ byte facility_req(dword Id, word Number,
                         
             sig_req(rplci,S_SERVICE,0);
             send_req(rplci);
-            return FALSE;
+            return false;
             break;
 
           case S_MWI_ACTIVATE:
@@ -2472,7 +2472,7 @@ byte facility_req(dword Id, word Number,
               {
                 rplci = &a->plci[i-1];
                 rplci->appl = appl;
-                rplci->cr_enquiry=TRUE;
+                rplci->cr_enquiry=true;
                 add_p(rplci,CAI,"\x01\x80");
                 add_p(rplci,UID,"\x06\x43\x61\x70\x69\x32\x30");
                 sig_req(rplci,ASSIGN,DSIG_ID);
@@ -2487,7 +2487,7 @@ byte facility_req(dword Id, word Number,
             else
             {
               rplci = plci;
-              rplci->cr_enquiry=FALSE;
+              rplci->cr_enquiry=false;
             }
 
             rplci->command = 0;
@@ -2509,7 +2509,7 @@ byte facility_req(dword Id, word Number,
             add_p(rplci,UID,ss_parms[10].info); /* Time */
             sig_req(rplci,S_SERVICE,0);
             send_req(rplci);
-            return FALSE;
+            return false;
 
           case S_MWI_DEACTIVATE:
             if(api_parse(&parms->info[1],(word)parms->length,"wbwwss",ss_parms))
@@ -2524,7 +2524,7 @@ byte facility_req(dword Id, word Number,
               {
                 rplci = &a->plci[i-1];
                 rplci->appl = appl;
-                rplci->cr_enquiry=TRUE;
+                rplci->cr_enquiry=true;
                 add_p(rplci,CAI,"\x01\x80");
                 add_p(rplci,UID,"\x06\x43\x61\x70\x69\x32\x30");
                 sig_req(rplci,ASSIGN,DSIG_ID);
@@ -2539,7 +2539,7 @@ byte facility_req(dword Id, word Number,
             else
             {
               rplci = plci;
-              rplci->cr_enquiry=FALSE;
+              rplci->cr_enquiry=false;
             }
 
             rplci->command = 0;
@@ -2556,7 +2556,7 @@ byte facility_req(dword Id, word Number,
             add_p(rplci,OAD,ss_parms[5].info); /* Controlling User Number */
             sig_req(rplci,S_SERVICE,0);
             send_req(rplci);
-            return FALSE;
+            return false;
 
           default:
             Info = 0x300E;  /* not supported */
@@ -2597,13 +2597,13 @@ byte facility_req(dword Id, word Number,
         Id,
         Number,
         "wws",Info,selector,SSparms);
-  return FALSE;
+  return false;
 }
 
 byte facility_res(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plci, APPL   * appl, API_PARSE * msg)
 {
   dbug(1,dprintf("facility_res"));
-  return FALSE;
+  return false;
 }
 
 byte connect_b3_req(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plci, APPL   * appl, API_PARSE * parms)
@@ -2649,7 +2649,7 @@ byte connect_b3_req(dword Id, word Numbe
               Id,
               Number,
               "w",Info);
-        return FALSE;
+        return false;
       }
       plci->requested_options_conn = 0;
 
@@ -2684,7 +2684,7 @@ byte connect_b3_req(dword Id, word Numbe
            || (fax_feature_bits & T30_FEATURE_BIT_MORE_DOCUMENTS))
           {
             len = (byte)(&(((T30_INFO *) 0)->universal_6));
-            fax_info_change = FALSE;
+            fax_info_change = false;
             if (ncpi->length >= 4)
             {
               w = GET_WORD(&ncpi->info[3]);
@@ -2693,7 +2693,7 @@ byte connect_b3_req(dword Id, word Numbe
                 ((T30_INFO   *)(plci->fax_connect_info_buffer))->resolution =
                   (byte)((((T30_INFO   *)(plci->fax_connect_info_buffer))->resolution & ~T30_RESOLUTION_R8_0770_OR_200) |
                   ((w & 0x0001) ? T30_RESOLUTION_R8_0770_OR_200 : 0));
-                fax_info_change = TRUE;
+                fax_info_change = true;
               }
               fax_control_bits &= ~(T30_CONTROL_BIT_REQUEST_POLLING | T30_CONTROL_BIT_MORE_DOCUMENTS);
               if (w & 0x0002)  /* Fax-polling request */
@@ -2709,7 +2709,7 @@ byte connect_b3_req(dword Id, word Numbe
                 if (((byte) w) != ((T30_INFO   *)(plci->fax_connect_info_buffer))->data_format)
                 {
                   ((T30_INFO   *)(plci->fax_connect_info_buffer))->data_format = (byte) w;
-                  fax_info_change = TRUE;
+                  fax_info_change = true;
                 }
 
                 if ((a->man_profile.private_options & (1L << PRIVATE_FAX_SUB_SEP_PWD))
@@ -2781,13 +2781,13 @@ byte connect_b3_req(dword Id, word Numbe
                 {
                   len = (byte)(&(((T30_INFO *) 0)->universal_6));
                 }
-                fax_info_change = TRUE;
+                fax_info_change = true;
 
               }
               if (fax_control_bits != GET_WORD(&((T30_INFO   *)plci->fax_connect_info_buffer)->control_bits_low))
               {
                 PUT_WORD (&((T30_INFO   *)plci->fax_connect_info_buffer)->control_bits_low, fax_control_bits);
-                fax_info_change = TRUE;
+                fax_info_change = true;
               }
             }
             if (Info == GOOD)
@@ -2798,12 +2798,12 @@ byte connect_b3_req(dword Id, word Numbe
                 if (fax_feature_bits & T30_FEATURE_BIT_MORE_DOCUMENTS)
                 {
                   start_internal_command (Id, plci, fax_connect_info_command);
-                  return FALSE;
+                  return false;
                 }
                 else
                 {
                   start_internal_command (Id, plci, fax_adjust_b23_command);
-                  return FALSE;
+                  return false;
                 }
               }
             }
@@ -2820,7 +2820,7 @@ byte connect_b3_req(dword Id, word Numbe
         for (w = 0; w < ncpi->length; w++)
           plci->internal_req_buffer[2+w] = ncpi->info[1+w];
         start_internal_command (Id, plci, rtp_connect_b3_req_command);
-        return FALSE;
+        return false;
       }
 
       if(!Info)
@@ -2837,7 +2837,7 @@ byte connect_b3_req(dword Id, word Numbe
         Id,
         Number,
         "w",Info);
-  return FALSE;
+  return false;
 }
 
 byte connect_b3_res(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plci, APPL   * appl, API_PARSE * parms)
@@ -2909,7 +2909,7 @@ byte connect_b3_res(dword Id, word Numbe
             plci->fax_connect_info_length = len;
             ((T30_INFO *)(plci->fax_connect_info_buffer))->code = 0;
             start_internal_command (Id, plci, fax_connect_ack_command);
-     return FALSE;
+     return false;
           }
         }
 
@@ -2932,7 +2932,7 @@ byte connect_b3_res(dword Id, word Numbe
         for (w = 0; w < ncpi->length; w++)
           plci->internal_req_buffer[2+w] = ncpi->info[1+w];
         start_internal_command (Id, plci, rtp_connect_b3_res_command);
-        return FALSE;
+        return false;
       }
 
       else
@@ -2945,14 +2945,14 @@ byte connect_b3_res(dword Id, word Numbe
         sendf(appl,_CONNECT_B3_ACTIVE_I,Id,0,"s","");
         if (plci->adjust_b_restore)
         {
-          plci->adjust_b_restore = FALSE;
+          plci->adjust_b_restore = false;
           start_internal_command (Id, plci, adjust_b_restore);
         }
       }
       return 1;
     }
   }
-  return FALSE;
+  return false;
 }
 
 byte connect_b3_a_res(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plci, APPL   * appl, API_PARSE * parms)
@@ -2972,7 +2972,7 @@ byte connect_b3_a_res(dword Id, word Num
       channel_xmit_xon (plci);
     }
   }
-  return FALSE;
+  return false;
 }
 
 byte disconnect_b3_req(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plci, APPL   * appl, API_PARSE * parms)
@@ -3004,7 +3004,7 @@ byte disconnect_b3_req(dword Id, word Nu
       {
         plci->send_disc = (byte)ncci;
         plci->command = 0;
-        return FALSE;
+        return false;
       }
       else
       {
@@ -3028,7 +3028,7 @@ byte disconnect_b3_req(dword Id, word Nu
         Id,
         Number,
         "w",Info);
-  return FALSE;
+  return false;
 }
 
 byte disconnect_b3_res(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plci, APPL   * appl, API_PARSE * parms)
@@ -3084,7 +3084,7 @@ byte disconnect_b3_res(dword Id, word Nu
       }
     }
   }
-  return FALSE;
+  return false;
 }
 
 byte data_b3_req(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plci, APPL   * appl, API_PARSE * parms)
@@ -3140,7 +3140,7 @@ byte data_b3_req(dword Id, word Number, 
       }
 
       send_data(plci);
-      return FALSE;
+      return false;
     }
   }
   if (appl)
@@ -3161,7 +3161,7 @@ byte data_b3_req(dword Id, word Number, 
           Number,
           "ww",GET_WORD(parms[2].info),Info);
   }
-  return FALSE;
+  return false;
 }
 
 byte data_b3_res(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plci, APPL   * appl, API_PARSE * parms)
@@ -3194,7 +3194,7 @@ byte data_b3_res(dword Id, word Number, 
       }
     }
   }
-  return FALSE;
+  return false;
 }
 
 byte reset_b3_req(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plci, APPL   * appl, API_PARSE * parms)
@@ -3235,7 +3235,7 @@ byte reset_b3_req(dword Id, word Number,
         Id,
         Number,
         "w",Info);
-  return FALSE;
+  return false;
 }
 
 byte reset_b3_res(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plci, APPL   * appl, API_PARSE * parms)
@@ -3254,12 +3254,12 @@ byte reset_b3_res(dword Id, word Number,
       {
         a->ncci_state[ncci] = CONNECTED;
         nl_req_ncci(plci,N_RESET_ACK,(byte)ncci);
-        return TRUE;
+        return true;
       }
     break;
     }
   }
-  return FALSE;
+  return false;
 }
 
 byte connect_b3_t90_a_res(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plci, APPL   * appl, API_PARSE * parms)
@@ -3292,7 +3292,7 @@ byte connect_b3_t90_a_res(dword Id, word
       return 1;
     }
   }
-  return FALSE;
+  return false;
 }
 
 
@@ -3378,7 +3378,7 @@ byte select_b_req(dword Id, word Number,
               plci->internal_command = BLOCK_PLCI; /* lock other commands */
               plci->command = 0;
               dbug(1,dprintf("continue if codec loaded"));
-              return FALSE;
+              return false;
             }
           }
         }
@@ -3407,12 +3407,12 @@ byte select_b_req(dword Id, word Number,
         else if (plci->call_dir & CALL_DIR_IN)
           plci->call_dir = CALL_DIR_IN | CALL_DIR_ANSWER;
         start_internal_command (Id, plci, select_b_command);
-        return FALSE;
+        return false;
       }
     }
   }
   sendf(appl, _SELECT_B_REQ|CONFIRM, Id, Number, "w", Info);
-  return FALSE;
+  return false;
 }
 
 byte manufacturer_req(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plci, APPL   * appl, API_PARSE * parms)
@@ -3489,7 +3489,7 @@ byte manufacturer_req(dword Id, word Num
           }
 
           plci->State = LOCAL_CONNECT;
-          plci->manufacturer = TRUE;
+          plci->manufacturer = true;
           plci->command = _MANUFACTURER_R;
           plci->m_command = command;
           plci->number = Number;
@@ -3520,7 +3520,7 @@ byte manufacturer_req(dword Id, word Num
                 plci->internal_command = BLOCK_PLCI; /* reject other req meanwhile */
                 plci->command = 0;
                 send_req(plci);
-                return FALSE;
+                return false;
               }
               if(dir==1) {
                 sig_req(plci,CALL_REQ,0);
@@ -3573,7 +3573,7 @@ byte manufacturer_req(dword Id, word Num
       }
       else if(req==LAW_REQ)
       {
-        plci->cr_enquiry = TRUE;
+        plci->cr_enquiry = true;
       }
       add_ss(plci,FTY,&m_parms[1]);
       sig_req(plci,req,0);
@@ -3739,7 +3739,7 @@ byte manufacturer_req(dword Id, word Num
         Id,
         Number,
         "dww",_DI_MANU_ID,command,Info);
-  return FALSE;
+  return false;
 }
 
 
@@ -3760,7 +3760,7 @@ byte manufacturer_res(dword Id, word Num
    || (msg[1].length == 0)
    || (GET_DWORD(msg[0].info)!=_DI_MANU_ID))
   {
-    return FALSE;
+    return false;
   }
   indication = GET_WORD(msg[1].info);
   switch (indication)
@@ -3811,7 +3811,7 @@ byte manufacturer_res(dword Id, word Num
     break;
 
   }
-  return FALSE;
+  return false;
 }
 
 /*------------------------------------------------------------------*/
@@ -3908,14 +3908,14 @@ void   callback(ENTITY   * e)
           plci->nl_req = 0;
       }
       if (plci->nl_req)
-        control_rc (plci, 0, rc, ch, 0, TRUE);
+        control_rc (plci, 0, rc, ch, 0, true);
       else
       {
         if (req == N_XON)
         {
           channel_x_on (plci, ch);
           if (plci->internal_command)
-            control_rc (plci, req, rc, ch, 0, TRUE);
+            control_rc (plci, req, rc, ch, 0, true);
         }
         else
         {
@@ -3931,21 +3931,21 @@ void   callback(ENTITY   * e)
               }
             }
             channel_xmit_xon (plci);
-            control_rc (plci, 0, rc, ch, global_req, TRUE);
+            control_rc (plci, 0, rc, ch, global_req, true);
           }
           else if (plci->data_sent)
           {
             channel_xmit_xon (plci);
-            plci->data_sent = FALSE;
+            plci->data_sent = false;
             plci->NL.XNum = 1;
             data_rc (plci, ch);
             if (plci->internal_command)
-              control_rc (plci, req, rc, ch, 0, TRUE);
+              control_rc (plci, req, rc, ch, 0, true);
           }
           else
           {
             channel_xmit_xon (plci);
-            control_rc (plci, req, rc, ch, 0, TRUE);
+            control_rc (plci, req, rc, ch, 0, true);
           }
         }
       }
@@ -3974,12 +3974,12 @@ void   callback(ENTITY   * e)
         if (rc != ASSIGN_OK)
           e->Id = 0;
         channel_xmit_xon (plci);
-        control_rc (plci, 0, rc, ch, global_req, FALSE);
+        control_rc (plci, 0, rc, ch, global_req, false);
       }
       else
       {
         channel_xmit_xon (plci);
-        control_rc (plci, req, rc, ch, 0, FALSE);
+        control_rc (plci, req, rc, ch, 0, false);
       }
     }
     /*
@@ -4065,8 +4065,8 @@ capi_callback_suffix:
 
     if (plci->li_notify_update)
     {
-      plci->li_notify_update = FALSE;
-      mixer_notify_update (plci, FALSE);
+      plci->li_notify_update = false;
+      mixer_notify_update (plci, false);
     }
 
   }
@@ -4428,7 +4428,7 @@ void control_rc(PLCI   * plci, byte req,
           else
           {
             sendf(appl,_INFO_R|CONFIRM,Id&0xf,Number,"w",_WRONG_STATE);
-            appl->NullCREnable = FALSE;
+            appl->NullCREnable = false;
             plci_remove(plci);
           }
         }
@@ -4441,7 +4441,7 @@ void control_rc(PLCI   * plci, byte req,
           else
           {
             sendf(appl,_INFO_R|CONFIRM,Id&0xf,Number,"w",_WRONG_STATE);
-            appl->NullCREnable = FALSE;
+            appl->NullCREnable = false;
           }
           plci_remove(plci);
         }
@@ -4862,7 +4862,7 @@ void sig_ind(PLCI   * plci)
     byte CF_Ind[] = "\x09\x02\x00\x06\x00\x00\x00\x00\x00\x00";
     byte Interr_Err_Ind[] = "\x0a\x02\x00\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00";
     byte CONF_Ind[] = "\x09\x16\x00\x06\x00\x00\0x00\0x00\0x00\0x00";
-  byte force_mt_info = FALSE;
+  byte force_mt_info = false;
   byte dir;
   dword d;
   word w;
@@ -4933,7 +4933,7 @@ void sig_ind(PLCI   * plci)
   {
     if(plci->cr_enquiry && plci->appl)
     {
-      plci->cr_enquiry = FALSE;
+      plci->cr_enquiry = false;
       /* d = MANU_ID            */
       /* w = m_command          */
       /* b = total length       */
@@ -5158,7 +5158,7 @@ void sig_ind(PLCI   * plci)
         if(application[i].CDEnable)
         {
           if(application[i].Id) sendf(&application[i],_FACILITY_I,Id,0,"ws",3, SS_Ind);
-          application[i].CDEnable = FALSE;
+          application[i].CDEnable = false;
         }
       }
       break;
@@ -5375,7 +5375,7 @@ void sig_ind(PLCI   * plci)
         if(application[i].CDEnable)
         {
           if(application[i].Id) sendf(&application[i],_FACILITY_I,Id,0,"ws",3, SS_Ind);
-          application[i].CDEnable = FALSE;
+          application[i].CDEnable = false;
         }
       }
       break;
@@ -5730,7 +5730,7 @@ void sig_ind(PLCI   * plci)
                         plci,
                         Id,
                         parms,
-                        SendMultiIE(plci,Id,multi_pi_parms, PI, 0x210, TRUE));
+                        SendMultiIE(plci,Id,multi_pi_parms, PI, 0x210, true));
         }
       }
       clear_c_ind_mask_bit (plci, MAX_APPL);
@@ -6117,38 +6117,38 @@ static void SendSetupInfo(APPL   * appl,
         dbug(1,dprintf("CPN "));
         Info_Number = 0x0070;
         Info_Mask   = 0x80;
-        Info_Sent_Flag = TRUE;
+        Info_Sent_Flag = true;
         break;
       case 8:  /* display      */
         dbug(1,dprintf("display(%d)",i));
         Info_Number = 0x0028;
         Info_Mask = 0x04;
-        Info_Sent_Flag = TRUE;
+        Info_Sent_Flag = true;
         break;
       case 16: /* Channel Id */
         dbug(1,dprintf("CHI"));
         Info_Number = 0x0018;
         Info_Mask = 0x100;
-        Info_Sent_Flag = TRUE;
+        Info_Sent_Flag = true;
         mixer_set_bchannel_id (plci, Info_Element);
         break;
       case 19: /* Redirected Number */
         dbug(1,dprintf("RDN"));
         Info_Number = 0x0074;
         Info_Mask = 0x400;
-        Info_Sent_Flag = TRUE;
+        Info_Sent_Flag = true;
         break;
       case 20: /* Redirected Number extended */
         dbug(1,dprintf("RDX"));
         Info_Number = 0x0073;
         Info_Mask = 0x400;
-        Info_Sent_Flag = TRUE;
+        Info_Sent_Flag = true;
         break;
       case 22: /* Redirecing Number  */
         dbug(1,dprintf("RIN"));
         Info_Number = 0x0076;
         Info_Mask = 0x400;
-        Info_Sent_Flag = TRUE;
+        Info_Sent_Flag = true;
         break;
       default:
         Info_Number = 0;
@@ -6312,7 +6312,7 @@ void SendInfo(PLCI   * plci, dword Id, b
         && plci->adapter->Info_Mask[appl->Id-1] &Info_Mask)
         {
           dbug(1,dprintf("NCR_Ind"));
-          iesent=TRUE;
+          iesent=true;
           sendf(&application[j],_INFO_I,Id&0x0f,0,"wS",Info_Number,Info_Element);
         }
       }
@@ -6330,7 +6330,7 @@ void SendInfo(PLCI   * plci, dword Id, b
           if(test_c_ind_mask_bit (plci, j))
           {
             dbug(1,dprintf("Ovl_Ind"));
-            iesent=TRUE;
+            iesent=true;
             sendf(&application[j],_INFO_I,Id,0,"wS",Info_Number,Info_Element);
           }
         }
@@ -6340,7 +6340,7 @@ void SendInfo(PLCI   * plci, dword Id, b
     && plci->adapter->Info_Mask[plci->appl->Id-1] &Info_Mask)
     {
       dbug(1,dprintf("Std_Ind"));
-      iesent=TRUE;
+      iesent=true;
       sendf(plci->appl,_INFO_I,Id,0,"wS",Info_Number,Info_Element);
     }
   }
@@ -6391,7 +6391,7 @@ byte SendMultiIE(PLCI   * plci, dword Id
         && appl->Id
         && plci->adapter->Info_Mask[appl->Id-1] &Info_Mask)
         {
-          iesent = TRUE;
+          iesent = true;
           dbug(1,dprintf("Mlt_NCR_Ind"));
           sendf(&application[j],_INFO_I,Id&0x0f,0,"wS",Info_Number,Info_Element);
         }
@@ -6403,7 +6403,7 @@ byte SendMultiIE(PLCI   * plci, dword Id
       {
         if(test_c_ind_mask_bit (plci, j))
         {
-          iesent = TRUE;
+          iesent = true;
           dbug(1,dprintf("Mlt_Ovl_Ind"));
           sendf(&application[j],_INFO_I,Id,0,"wS",Info_Number,Info_Element);
         }
@@ -6412,7 +6412,7 @@ byte SendMultiIE(PLCI   * plci, dword Id
     else if(Info_Number
     && plci->adapter->Info_Mask[plci->appl->Id-1] &Info_Mask)
     {
-      iesent = TRUE;
+      iesent = true;
       dbug(1,dprintf("Mlt_Std_Ind"));
       sendf(plci->appl,_INFO_I,Id,0,"wS",Info_Number,Info_Element);
     }
@@ -6887,7 +6887,7 @@ void nl_ind(PLCI   * plci)
           (byte)(plci->ncpi_buffer[0] + 1), plci->ncpi_buffer);
         plci->ncpi_state |= NCPI_NEGOTIATE_B3_SENT;
  if (plci->nsf_control_bits & T30_NSF_CONTROL_BIT_NEGOTIATE_RESP)
-   fax_send_edata_ack = FALSE;
+   fax_send_edata_ack = false;
       }
 
       if (a->manufacturer_features & MANUFACTURER_FEATURE_FAX_PAPER_FORMATS)
@@ -6928,7 +6928,7 @@ void nl_ind(PLCI   * plci)
             sendf(plci->appl,_DISCONNECT_B3_I,Id,0,"wS",GOOD,plci->ncpi_buffer);
             a->ncci_state[ncci] = INC_DIS_PENDING;
             plci->ncpi_state = 0;
-     fax_send_edata_ack = FALSE;
+     fax_send_edata_ack = false;
           }
           break;
         }
@@ -7025,7 +7025,7 @@ void nl_ind(PLCI   * plci)
     }
     if (plci->adjust_b_restore)
     {
-      plci->adjust_b_restore = FALSE;
+      plci->adjust_b_restore = false;
       start_internal_command (Id, plci, adjust_b_restore);
     }
     break;
@@ -7041,7 +7041,7 @@ void nl_ind(PLCI   * plci)
         next_internal_command (Id, plci);
     }
     ncci_state = a->ncci_state[ncci];
-    ncci_remove (plci, ncci, FALSE);
+    ncci_remove (plci, ncci, false);
 
         /* with N_DISC or N_DISC_ACK the IDI frees the respective   */
         /* channel, so we cannot store the state in ncci_state! The */
@@ -7288,18 +7288,18 @@ word get_plci(DIVA_CAPI_ADAPTER   * a)
   plci->msg_in_read_pos = MSG_IN_QUEUE_SIZE;
   plci->msg_in_wrap_pos = MSG_IN_QUEUE_SIZE;
 
-  plci->data_sent = FALSE;
+  plci->data_sent = false;
   plci->send_disc = 0;
   plci->sig_global_req = 0;
   plci->sig_remove_id = 0;
   plci->nl_global_req = 0;
   plci->nl_remove_id = 0;
   plci->adv_nl = 0;
-  plci->manufacturer = FALSE;
+  plci->manufacturer = false;
   plci->call_dir = CALL_DIR_OUT | CALL_DIR_ORIGINATE;
   plci->spoofed_msg = 0;
   plci->ptyState = 0;
-  plci->cr_enquiry = FALSE;
+  plci->cr_enquiry = false;
   plci->hangup_flow_ctrl_timer = 0;
 
   plci->ncci_ring_list = 0;
@@ -7972,7 +7972,7 @@ word add_b23(PLCI   * plci, API_PARSE * 
 
   if(!bp->length && plci->tel)
   {
-    plci->adv_nl = TRUE;
+    plci->adv_nl = true;
     dbug(1,dprintf("Default adv.Nl"));
     add_p(plci,LLI,lli);
     plci->B2_prot = 1 /*XPARENT*/;
@@ -8022,7 +8022,7 @@ word add_b23(PLCI   * plci, API_PARSE * 
   {  
     if(GET_WORD(bp_parms[1].info)!=1
     || GET_WORD(bp_parms[2].info)!=0) return _B2_NOT_SUPPORTED;
-    plci->adv_nl = TRUE;
+    plci->adv_nl = true;
   }
   else if(plci->tel) return _B2_NOT_SUPPORTED;
 
@@ -8840,7 +8840,7 @@ void send_data(PLCI   * plci)
             plci->NL.X = plci->NData;
             plci->NL.ReqCh = a->ncci_ch[ncci];
             dbug(1,dprintf("%x:DREQ(%x:%x)",a->Id,plci->NL.Id,plci->NL.Req));
-            plci->data_sent = TRUE;
+            plci->data_sent = true;
             plci->data_sent_ptr = data->P;
             a->request(&plci->NL);
           }
@@ -8995,10 +8995,10 @@ void IndParse(PLCI   * plci, word * parm
 byte ie_compare(byte   * ie1, byte * ie2)
 {
   word i;
-  if(!ie1 || ! ie2) return FALSE;
-  if(!ie1[0]) return FALSE;
-  for(i=0;i<(word)(ie1[0]+1);i++) if(ie1[i]!=ie2[i]) return FALSE;
-  return TRUE;
+  if(!ie1 || ! ie2) return false;
+  if(!ie1[0]) return false;
+  for(i=0;i<(word)(ie1[0]+1);i++) if(ie1[i]!=ie2[i]) return false;
+  return true;
 }
 
 word find_cip(DIVA_CAPI_ADAPTER   * a, byte   * bc, byte   * hlc)
@@ -9151,7 +9151,7 @@ word AdvCodecSupport(DIVA_CAPI_ADAPTER  
         plci->tel=ADV_VOICE;
       }
       a->AdvSignalAppl = appl;
-      a->AdvCodecFLAG = TRUE;
+      a->AdvCodecFLAG = true;
       a->AdvCodecPLCI = splci;
       add_p(splci,CAI,"\x01\x15");
       add_p(splci,LLI,"\x01\x00");
@@ -9183,7 +9183,7 @@ word AdvCodecSupport(DIVA_CAPI_ADAPTER  
         add_p(splci,UID,"\x06\x43\x61\x70\x69\x32\x30");
         sig_req(splci,ASSIGN,0xC0);  /* 0xc0 is the TEL_ID */
         send_req(splci);
-        a->scom_appl_disable = TRUE;
+        a->scom_appl_disable = true;
       }
       else{
         return 0x2001; /* wrong state, no more plcis */
@@ -9411,7 +9411,7 @@ word CapiRelease(word Id)
       }
       if(a->AdvSignalAppl==this)
       {
-        this->NullCREnable = FALSE;
+        this->NullCREnable = false;
         if (a->AdvCodecPLCI)
         {
           plci_remove(a->AdvCodecPLCI);
@@ -9433,7 +9433,7 @@ word CapiRelease(word Id)
 
 static word plci_remove_check(PLCI   *plci)
 {
-  if(!plci) return TRUE;
+  if(!plci) return true;
   if(!plci->NL.Id && c_ind_mask_empty (plci))
   {
     if(plci->Sig.Id == 0xff)
@@ -9446,7 +9446,7 @@ static word plci_remove_check(PLCI   *pl
       {
         CodecIdCheck(plci->adapter, plci);
         clear_b1_config (plci);
-        ncci_remove (plci, 0, FALSE);
+        ncci_remove (plci, 0, false);
         plci_free_msg_in_queue (plci);
         channel_flow_control_remove (plci);
         plci->Id = 0;
@@ -9456,10 +9456,10 @@ static word plci_remove_check(PLCI   *pl
         plci->notifiedcall = 0;
       }
       listen_check(plci->adapter);
-      return TRUE;
+      return true;
     }
   }
-  return FALSE;
+  return false;
 }
 
 
@@ -9815,7 +9815,7 @@ static void dtmf_command (dword Id, PLCI
         }
         plci->dtmf_rec_active &= ~mask;
         plci->internal_command = DTMF_COMMAND_2;
-        dtmf_enable_receiver (plci, FALSE);
+        dtmf_enable_receiver (plci, false);
         return;
       }
       Rc = OK;
@@ -10020,7 +10020,7 @@ static byte dtmf_request (dword Id, word
           }
         }
         start_internal_command (Id, plci, dtmf_command);
-        return (FALSE);
+        return (false);
 
 
       case DTMF_SEND_TONE:
@@ -10079,7 +10079,7 @@ static byte dtmf_request (dword Id, word
         }
         api_save_msg (dtmf_parms, "wwws", &plci->saved_msg);
         start_internal_command (Id, plci, dtmf_command);
-        return (FALSE);
+        return (false);
 
       default:
         dbug (1, dprintf ("[%06lx] %s,%d: DTMF unknown request %04x",
@@ -10090,7 +10090,7 @@ static byte dtmf_request (dword Id, word
   }
   sendf (appl, _FACILITY_R | CONFIRM, Id & 0xffffL, Number,
     "wws", Info, SELECTOR_DTMF, result);
-  return (FALSE);
+  return (false);
 }
 
 
@@ -10842,10 +10842,10 @@ static struct
   byte to_pc;
 } xconnect_write_prog[] =
 {
-  { LI_COEF_CH_CH, FALSE, FALSE },
-  { LI_COEF_CH_PC, FALSE, TRUE },
-  { LI_COEF_PC_CH, TRUE, FALSE },
-  { LI_COEF_PC_PC, TRUE, TRUE }
+  { LI_COEF_CH_CH, false, false },
+  { LI_COEF_CH_PC, false, true },
+  { LI_COEF_PC_CH, true, false },
+  { LI_COEF_PC_PC, true, true }
 };
 
 
@@ -10916,7 +10916,7 @@ static byte xconnect_write_coefs_process
   {
     dbug (1, dprintf ("[%06x] %s,%d: Channel id wiped out",
       UnMapId (Id), (char   *)(FILE_), __LINE__));
-    return (TRUE);
+    return (true);
   }
   i = a->li_base + (plci->li_bchannel_id - 1);
   j = plci->li_write_channel;
@@ -10927,7 +10927,7 @@ static byte xconnect_write_coefs_process
     {
       dbug (1, dprintf ("[%06lx] %s,%d: LI write coefs failed %02x",
         UnMapId (Id), (char   *)(FILE_), __LINE__, Rc));
-      return (FALSE);
+      return (false);
     }
   }
   if (li_config_table[i].adapter->manufacturer_features & MANUFACTURER_FEATURE_XCONNECT)
@@ -10969,7 +10969,7 @@ static byte xconnect_write_coefs_process
     {
       plci->internal_command = plci->li_write_command;
       if (plci_nl_busy (plci))
-        return (TRUE);
+        return (true);
       to_ch = (a->li_pri) ? plci->li_bchannel_id - 1 : 0;
       *(p++) = UDATA_REQUEST_XCONNECT_TO;
       do
@@ -11050,7 +11050,7 @@ static byte xconnect_write_coefs_process
     {
       plci->internal_command = plci->li_write_command;
       if (plci_nl_busy (plci))
-        return (TRUE);
+        return (true);
       if (a->li_pri)
       {
         *(p++) = UDATA_REQUEST_SET_MIXER_COEFS_PRI_SYNC;
@@ -11127,7 +11127,7 @@ static byte xconnect_write_coefs_process
     {
       plci->internal_command = plci->li_write_command;
       if (plci_nl_busy (plci))
-        return (TRUE);
+        return (true);
       if (j < a->li_base)
         j = a->li_base;
       if (a->li_pri)
@@ -11232,7 +11232,7 @@ static byte xconnect_write_coefs_process
     plci->NL.Req = plci->nl_req = (byte) N_UDATA;
     plci->adapter->request (&plci->NL);
   }
-  return (TRUE);
+  return (true);
 }
 
 
@@ -11251,7 +11251,7 @@ static void mixer_notify_update (PLCI   
   if (a->profile.Global_Options & GL_LINE_INTERCONNECT_SUPPORTED)
   {
     if (others)
-      plci->li_notify_update = TRUE;
+      plci->li_notify_update = true;
     i = 0;
     do
     {
@@ -11277,7 +11277,7 @@ static void mixer_notify_update (PLCI   
        && (notify_plci->State)
        && notify_plci->NL.Id && !notify_plci->nl_remove_id)
       {
-        notify_plci->li_notify_update = TRUE;
+        notify_plci->li_notify_update = true;
         ((CAPI_MSG *) msg)->header.length = 18;
         ((CAPI_MSG *) msg)->header.appl_id = notify_plci->appl->Id;
         ((CAPI_MSG *) msg)->header.command = _FACILITY_R;
@@ -11299,12 +11299,12 @@ static void mixer_notify_update (PLCI   
               (char   *)(FILE_), __LINE__,
               (dword)((notify_plci->Id << 8) | UnMapController (notify_plci->adapter->Id)), w));
           }
-          notify_plci->li_notify_update = FALSE;
+          notify_plci->li_notify_update = false;
         }
       }
     } while (others && (notify_plci != NULL));
     if (others)
-      plci->li_notify_update = FALSE;
+      plci->li_notify_update = false;
   }
 }
 
@@ -11318,7 +11318,7 @@ static void mixer_clear_config (PLCI   *
     (dword)((plci->Id << 8) | UnMapController (plci->adapter->Id)),
     (char   *)(FILE_), __LINE__));
 
-  plci->li_notify_update = FALSE;
+  plci->li_notify_update = false;
   plci->li_plci_b_write_pos = 0;
   plci->li_plci_b_read_pos = 0;
   plci->li_plci_b_req_pos = 0;
@@ -12159,7 +12159,7 @@ static byte mixer_request (dword Id, wor
         plci_b = li_check_plci_b (Id, plci, plci_b_id, plci_b_write_pos, &result[8]);
         if (plci_b == NULL)
           break;
-        li_update_connect (Id, a, plci, plci_b_id, TRUE, li_flags);
+        li_update_connect (Id, a, plci, plci_b_id, true, li_flags);
         plci->li_plci_b_queue[plci_b_write_pos] = plci_b_id | LI_PLCI_B_LAST_FLAG;
         plci_b_write_pos = (plci_b_write_pos == LI_PLCI_B_QUEUE_ENTRIES-1) ? 0 : plci_b_write_pos + 1;
         plci->li_plci_b_write_pos = plci_b_write_pos;
@@ -12188,7 +12188,7 @@ static byte mixer_request (dword Id, wor
         plci_b_write_pos = plci->li_plci_b_write_pos;
         participant_parms_pos = 0;
         result_pos = 7;
-        li2_update_connect (Id, a, plci, UnMapId (Id), TRUE, li_flags);
+        li2_update_connect (Id, a, plci, UnMapId (Id), true, li_flags);
         while (participant_parms_pos < li_req_parms[1].length)
         {
           result[result_pos] = 6;
@@ -12224,7 +12224,7 @@ static byte mixer_request (dword Id, wor
           plci_b = li2_check_plci_b (Id, plci, plci_b_id, plci_b_write_pos, &result[result_pos - 2]);
           if (plci_b != NULL)
           {
-            li2_update_connect (Id, a, plci, plci_b_id, TRUE, li_flags);
+            li2_update_connect (Id, a, plci, plci_b_id, true, li_flags);
             plci->li_plci_b_queue[plci_b_write_pos] = plci_b_id |
               ((li_flags & (LI2_FLAG_INTERCONNECT_A_B | LI2_FLAG_INTERCONNECT_B_A |
               LI2_FLAG_PCCONNECT_A_B | LI2_FLAG_PCCONNECT_B_A)) ? 0 : LI_PLCI_B_DISC_FLAG);
@@ -12249,13 +12249,13 @@ static byte mixer_request (dword Id, wor
       }
       mixer_calculate_coefs (a);
       plci->li_channel_bits = li_config_table[a->li_base + (plci->li_bchannel_id - 1)].channel;
-      mixer_notify_update (plci, TRUE);
+      mixer_notify_update (plci, true);
       sendf (appl, _FACILITY_R | CONFIRM, Id & 0xffffL, Number,
         "wwS", Info, SELECTOR_LINE_INTERCONNECT, result);
       plci->command = 0;
       plci->li_cmd = GET_WORD (li_parms[0].info);
       start_internal_command (Id, plci, mixer_command);
-      return (FALSE);
+      return (false);
 
     case LI_REQ_DISCONNECT:
       if (li_parms[1].length == 4)
@@ -12283,7 +12283,7 @@ static byte mixer_request (dword Id, wor
         plci_b = li_check_plci_b (Id, plci, plci_b_id, plci_b_write_pos, &result[8]);
         if (plci_b == NULL)
           break;
-        li_update_connect (Id, a, plci, plci_b_id, FALSE, 0);
+        li_update_connect (Id, a, plci, plci_b_id, false, 0);
         plci->li_plci_b_queue[plci_b_write_pos] = plci_b_id | LI_PLCI_B_DISC_FLAG | LI_PLCI_B_LAST_FLAG;
         plci_b_write_pos = (plci_b_write_pos == LI_PLCI_B_QUEUE_ENTRIES-1) ? 0 : plci_b_write_pos + 1;
         plci->li_plci_b_write_pos = plci_b_write_pos;
@@ -12345,7 +12345,7 @@ static byte mixer_request (dword Id, wor
           plci_b = li2_check_plci_b (Id, plci, plci_b_id, plci_b_write_pos, &result[result_pos - 2]);
           if (plci_b != NULL)
           {
-            li2_update_connect (Id, a, plci, plci_b_id, FALSE, 0);
+            li2_update_connect (Id, a, plci, plci_b_id, false, 0);
             plci->li_plci_b_queue[plci_b_write_pos] = plci_b_id | LI_PLCI_B_DISC_FLAG;
             plci_b_write_pos = (plci_b_write_pos == LI_PLCI_B_QUEUE_ENTRIES-1) ? 0 : plci_b_write_pos + 1;
           }
@@ -12368,13 +12368,13 @@ static byte mixer_request (dword Id, wor
       }
       mixer_calculate_coefs (a);
       plci->li_channel_bits = li_config_table[a->li_base + (plci->li_bchannel_id - 1)].channel;
-      mixer_notify_update (plci, TRUE);
+      mixer_notify_update (plci, true);
       sendf (appl, _FACILITY_R | CONFIRM, Id & 0xffffL, Number,
         "wwS", Info, SELECTOR_LINE_INTERCONNECT, result);
       plci->command = 0;
       plci->li_cmd = GET_WORD (li_parms[0].info);
       start_internal_command (Id, plci, mixer_command);
-      return (FALSE);
+      return (false);
 
     case LI_REQ_SILENT_UPDATE:
       if (!plci || !plci->State
@@ -12384,7 +12384,7 @@ static byte mixer_request (dword Id, wor
       {
         dbug (1, dprintf ("[%06lx] %s,%d: Wrong state",
           UnMapId (Id), (char   *)(FILE_), __LINE__));
-        return (FALSE);
+        return (false);
       }
       plci_b_write_pos = plci->li_plci_b_write_pos;
       if (((plci->li_plci_b_read_pos > plci_b_write_pos) ? plci->li_plci_b_read_pos :
@@ -12392,7 +12392,7 @@ static byte mixer_request (dword Id, wor
       {
         dbug (1, dprintf ("[%06lx] %s,%d: LI request overrun",
           UnMapId (Id), (char   *)(FILE_), __LINE__));
-        return (FALSE);
+        return (false);
       }
       i = (plci_b_write_pos == 0) ? LI_PLCI_B_QUEUE_ENTRIES-1 : plci_b_write_pos - 1;
       if ((plci_b_write_pos == plci->li_plci_b_read_pos)
@@ -12408,7 +12408,7 @@ static byte mixer_request (dword Id, wor
       plci->command = 0;
       plci->li_cmd = GET_WORD (li_parms[0].info);
       start_internal_command (Id, plci, mixer_command);
-      return (FALSE);
+      return (false);
 
     default:
       dbug (1, dprintf ("[%06lx] %s,%d: LI unknown request %04x",
@@ -12418,7 +12418,7 @@ static byte mixer_request (dword Id, wor
   }
   sendf (appl, _FACILITY_R | CONFIRM, Id & 0xffffL, Number,
     "wwS", Info, SELECTOR_LINE_INTERCONNECT, result);
-  return (FALSE);
+  return (false);
 }
 
 
@@ -12523,7 +12523,7 @@ static void mixer_indication_xconnect_fr
     if (!plci->internal_command)
       next_internal_command (Id, plci);
   }
-  mixer_notify_update (plci, TRUE);
+  mixer_notify_update (plci, true);
 }
 
 
@@ -12547,12 +12547,12 @@ static byte mixer_notify_source_removed 
     dbug (1, dprintf ("[%06lx] %s,%d: LI request overrun",
       (dword)((plci->Id << 8) | UnMapController (plci->adapter->Id)),
       (char   *)(FILE_), __LINE__));
-    return (FALSE);
+    return (false);
   }
   plci->li_plci_b_queue[plci_b_write_pos] = plci_b_id | LI_PLCI_B_DISC_FLAG;
   plci_b_write_pos = (plci_b_write_pos == LI_PLCI_B_QUEUE_ENTRIES-1) ? 0 : plci_b_write_pos + 1;
   plci->li_plci_b_write_pos = plci_b_write_pos;
-  return (TRUE);
+  return (true);
 }
 
 
@@ -12596,7 +12596,7 @@ static void mixer_remove (PLCI   *plci)
         }
         mixer_clear_config (plci);
         mixer_calculate_coefs (a);
-        mixer_notify_update (plci, TRUE);
+        mixer_notify_update (plci, true);
       }
       li_config_table[i].plci = NULL;
       plci->li_bchannel_id = 0;
@@ -12883,29 +12883,29 @@ static byte ec_request (dword Id, word N
           case EC_ENABLE_OPERATION:
             plci->ec_idi_options &= ~LEC_FREEZE_COEFFICIENTS;
             start_internal_command (Id, plci, ec_command);
-            return (FALSE);
+            return (false);
 
           case EC_DISABLE_OPERATION:
             plci->ec_idi_options = LEC_ENABLE_ECHO_CANCELLER |
               LEC_MANUAL_DISABLE | LEC_ENABLE_NONLINEAR_PROCESSING |
               LEC_RESET_COEFFICIENTS;
             start_internal_command (Id, plci, ec_command);
-            return (FALSE);
+            return (false);
 
           case EC_FREEZE_COEFFICIENTS:
             plci->ec_idi_options |= LEC_FREEZE_COEFFICIENTS;
             start_internal_command (Id, plci, ec_command);
-            return (FALSE);
+            return (false);
 
           case EC_RESUME_COEFFICIENT_UPDATE:
             plci->ec_idi_options &= ~LEC_FREEZE_COEFFICIENTS;
             start_internal_command (Id, plci, ec_command);
-            return (FALSE);
+            return (false);
 
           case EC_RESET_COEFFICIENTS:
             plci->ec_idi_options |= LEC_RESET_COEFFICIENTS;
             start_internal_command (Id, plci, ec_command);
-            return (FALSE);
+            return (false);
 
           default:
             dbug (1, dprintf ("[%06lx] %s,%d: EC unknown request %04x",
@@ -12978,14 +12978,14 @@ static byte ec_request (dword Id, word N
           case EC_ENABLE_OPERATION:
             plci->ec_idi_options &= ~LEC_FREEZE_COEFFICIENTS;
             start_internal_command (Id, plci, ec_command);
-            return (FALSE);
+            return (false);
 
           case EC_DISABLE_OPERATION:
             plci->ec_idi_options = LEC_ENABLE_ECHO_CANCELLER |
               LEC_MANUAL_DISABLE | LEC_ENABLE_NONLINEAR_PROCESSING |
               LEC_RESET_COEFFICIENTS;
             start_internal_command (Id, plci, ec_command);
-            return (FALSE);
+            return (false);
 
           default:
             dbug (1, dprintf ("[%06lx] %s,%d: EC unknown request %04x",
@@ -12999,7 +12999,7 @@ static byte ec_request (dword Id, word N
   sendf (appl, _FACILITY_R | CONFIRM, Id & 0xffffL, Number,
     "wws", Info, (appl->appl_flags & APPL_FLAG_PRIV_EC_SPEC) ?
     PRIV_SELECTOR_ECHO_CANCELLER : SELECTOR_ECHO_CANCELLER, result);
-  return (FALSE);
+  return (false);
 }
 
 
@@ -13563,7 +13563,7 @@ static void adjust_b_clear (PLCI   *plci
     (dword)((plci->Id << 8) | UnMapController (plci->adapter->Id)),
     (char   *)(FILE_), __LINE__));
 
-  plci->adjust_b_restore = FALSE;
+  plci->adjust_b_restore = false;
 }
 
 
@@ -13832,7 +13832,7 @@ static word adjust_b_process (dword Id, 
     }
     if (plci->adjust_b_mode & ADJUST_B_MODE_USER_CONNECT)
     {
-      plci->adjust_b_restore = TRUE;
+      plci->adjust_b_restore = true;
       break;
     }
     plci->adjust_b_state = ADJUST_B_CONNECT_1;
@@ -14768,19 +14768,19 @@ static void group_optimization(DIVA_CAPI
   {
     if(application[i].Id && a->CIP_Mask[i] )
     {
-      for(k=0,busy=FALSE; k<a->max_plci; k++)
+      for(k=0,busy=false; k<a->max_plci; k++)
       {
         if(a->plci[k].Id) 
         {
           auxplci = &a->plci[k];
           if(auxplci->appl == &application[i]) /* application has a busy PLCI */
           {
-            busy = TRUE;
+            busy = true;
             dbug(1,dprintf("Appl 0x%x is busy",i+1));
           }
           else if(test_c_ind_mask_bit (auxplci, i)) /* application has an incoming call pending */
           {
-            busy = TRUE;
+            busy = true;
             dbug(1,dprintf("Appl 0x%x has inc. call pending",i+1));
           }
         }
@@ -14791,13 +14791,13 @@ static void group_optimization(DIVA_CAPI
         if(j==MAX_CIP_TYPES)       /* all groups are in use but group still not found */
         {                           /* the MAX_CIP_TYPES group enables all calls because of field overflow */
           appl_number_group_type[i] = MAX_CIP_TYPES;
-          group_found=TRUE;
+          group_found=true;
           dbug(1,dprintf("Field overflow appl 0x%x",i+1));
         }
         else if( (info_mask_group[j]==a->CIP_Mask[i]) && (cip_mask_group[j]==a->Info_Mask[i]) )  
         {                                      /* is group already present ?                  */
           appl_number_group_type[i] = j|0x80;  /* store the group number for each application */
-          group_found=TRUE;
+          group_found=true;
           dbug(1,dprintf("Group 0x%x found with appl 0x%x, CIP=0x%lx",appl_number_group_type[i],i+1,info_mask_group[j]));
         }
         else if(!info_mask_group[j])
@@ -14805,7 +14805,7 @@ static void group_optimization(DIVA_CAPI
           appl_number_group_type[i] = j|0x80;  /* store the group number for each application */
           info_mask_group[j] = a->CIP_Mask[i]; /* store the new CIP mask for the new group    */
           cip_mask_group[j] = a->Info_Mask[i]; /* store the new Info_Mask for this new group  */
-          group_found=TRUE;
+          group_found=true;
           dbug(1,dprintf("New Group 0x%x established with appl 0x%x, CIP=0x%lx",appl_number_group_type[i],i+1,info_mask_group[j]));
         }
       }
@@ -14860,7 +14860,7 @@ word CapiRegister(word id)
     }
   }
 
-  if(appls_found) return TRUE;
+  if(appls_found) return true;
   for(i=0; i<max_adapter; i++)                   /* scan all adapters...    */
   {
     a = &adapter[i];
@@ -14889,7 +14889,7 @@ word CapiRegister(word id)
       }
     }
   }
-  return FALSE;
+  return false;
 }
 
 /*------------------------------------------------------------------*/
diff -puN drivers/isdn/hardware/eicon/os_pri.c~drivers-isdn-hardware-eicon-convert-to-generic-boolean-values drivers/isdn/hardware/eicon/os_pri.c
--- a/drivers/isdn/hardware/eicon/os_pri.c~drivers-isdn-hardware-eicon-convert-to-generic-boolean-values
+++ a/drivers/isdn/hardware/eicon/os_pri.c
@@ -487,7 +487,7 @@ diva_pri_start_adapter(PISDN_ADAPTER IoA
 	}
 	DIVA_OS_MEM_DETACH_ADDRESS(IoAdapter, boot);
 
-	IoAdapter->Initialized = TRUE;
+	IoAdapter->Initialized = true;
 
 	/*
 	   Check Interrupt
@@ -504,7 +504,7 @@ diva_pri_start_adapter(PISDN_ADAPTER IoA
 	if (!IoAdapter->IrqCount) {
 		DBG_ERR(("A: A(%d) interrupt test failed",
 			 IoAdapter->ANum))
-		IoAdapter->Initialized = FALSE;
+		IoAdapter->Initialized = false;
 		IoAdapter->stop(IoAdapter);
 		return (-1);
 	}
diff -puN drivers/isdn/hardware/eicon/platform.h~drivers-isdn-hardware-eicon-convert-to-generic-boolean-values drivers/isdn/hardware/eicon/platform.h
--- a/drivers/isdn/hardware/eicon/platform.h~drivers-isdn-hardware-eicon-convert-to-generic-boolean-values
+++ a/drivers/isdn/hardware/eicon/platform.h
@@ -71,14 +71,6 @@
 #define	qword  u64
 #endif
 
-#ifndef	TRUE
-#define	TRUE	1
-#endif
-
-#ifndef	FALSE
-#define	FALSE	0
-#endif
-
 #ifndef	NULL
 #define	NULL	((void *) 0)
 #endif
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

drivers-media-video-convert-to-generic-boolean-values.patch
hp100-convert-pci_module_init-to-pci_register_driver.patch
drivers-scsi-buslogic-replace-boolean-by-bool.patch
git-cryptodev.patch
drivers-block-dac960-converted-boolean-to-bool.patch
drivers-isdn-hardware-eicon-convert-to-generic-boolean-values.patch
